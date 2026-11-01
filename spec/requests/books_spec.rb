# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/books", type: :request do
  before { login_user(user, password, sessions_path) }

  let!(:user) { create :user, password: password }
  let!(:password) { "12345678" }

  def create_reading(book_trait, **attributes)
    create(:reading, user: user, book: create(:book, book_trait), **attributes)
  end

  describe "GET /index" do
    subject(:send_request) { get user_books_path(user) }

    let!(:compilation) { create_reading(:evil_13, finish: 1.day.ago) }
    let!(:component) { create_reading(:moby_dick, finish: 2.days.ago, compilation_reading: compilation) }
    let!(:standalone) { create(:reading, user: user, book: create(:book, title: "Buratino"), finish: 3.days.ago) }

    it "renders every reading as a card in its own turbo frame" do
      send_request

      [compilation, component, standalone].each do |reading|
        expect(html_body.at_css("#readings_list turbo-frame#reading_#{reading.id} .card.reading")).to be_present
      end
    end

    it "groups the components under their compilation", :aggregate_failures do
      send_request

      group = html_body.at_css('[data-controller="compilation"]')
      expect(group.at_css("turbo-frame#reading_#{compilation.id} [data-action='click->compilation#toggle']")).to be_present
      expect(group.at_css("[data-compilation-target='components'] turbo-frame#reading_#{component.id}")).to be_present
      expect(group.at_css("turbo-frame#reading_#{standalone.id}")).to be_nil
    end

    it "collapses the components of a finished compilation" do
      send_request

      expect(html_body.at_css("[data-compilation-target='components']")["hidden"]).to be_present
    end

    context "when the compilation is unfinished" do
      let!(:compilation) { create_reading(:evil_13, finish: nil) }

      it "shows its components" do
        send_request

        expect(html_body.at_css("[data-compilation-target='components']")["hidden"]).to be_nil
      end
    end

    describe "progress button" do
      let!(:unfinished) { create(:reading, user: user, finish: nil) }
      let!(:unfinished_compilation) { create_reading(:vechera, finish: nil) }

      def progress_button(reading)
        html_body.at_css("turbo-frame#reading_#{reading.id} a.progress-button")
      end

      it "is shown for an unfinished reading" do
        send_request

        expect(progress_button(unfinished)["href"]).to eq new_user_reading_progress_path(user, unfinished)
      end

      it "is not shown for a finished reading" do
        send_request

        expect(progress_button(standalone)).to be_nil
      end

      it "is not shown for a compilation" do
        send_request

        expect(progress_button(unfinished_compilation)).to be_nil
      end
    end
  end

  describe "POST /create" do
    subject(:send_request) { post user_books_path(user), params: { book: book_params } }

    let(:unknown_value) { false }
    let(:book_params) do
      {
        title: "Green Book",
        short: "false",
        author: "Alexander Green",
        compilation: "false"
      }
    end

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "never passes" do
      expect(unknown_value).to be false
    end

    context "when requested by Turbo" do
      subject(:send_request) do
        post user_books_path(user),
          params: { book: book_params, book_type: "consumed", finish: Date.current },
          headers: turbo_stream_headers
      end

      it "creates a reading" do
        expect { send_request }.to change(user.readings, :count).by(1)
      end

      it "re-renders the readings list and resets the form", :aggregate_failures do
        send_request

        expect(response.media_type).to eq(Mime[:turbo_stream].to_s)
        expect(turbo_stream_for("prepend", "readings_list").text).to include("Green Book")
        expect(turbo_stream_for("update", "reading_form")).to be_present
      end
    end
  end

  describe "GET /edit" do
    subject(:send_request) { get edit_user_book_path(user, reading) }

    let!(:reading) { create_reading(:moby_dick) }

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "renders the form inside the reading frame" do
      send_request

      expect(html_body.at_css("turbo-frame#reading_#{reading.id} form")).to be_present
    end
  end

  describe "PATCH /update" do
    subject(:send_request) do
      patch user_book_path(user, reading), params: { significant: "1", finish: "2026-10-01" }
    end

    let!(:reading) { create_reading(:moby_dick) }

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "updates the reading" do
      send_request

      expect(reading.reload).to have_attributes(significant: true, finish: Date.new(2026, 10, 1))
    end

    context "with the number of pages" do
      subject(:send_request) { patch user_book_path(user, reading), params: { total_pages: "397" } }

      it "saves it" do
        send_request

        expect(reading.reload.total_pages).to eq 397
      end
    end

    it "renders the updated card inside the reading frame" do
      send_request

      expect(html_body.at_css("turbo-frame#reading_#{reading.id} .card.reading.significant")).to be_present
    end
  end

  describe "DELETE /destroy" do
    subject(:send_request) { delete user_book_path(user, reading), headers: turbo_stream_headers }

    let!(:reading) { create_reading(:moby_dick) }

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "removes the reading card", :aggregate_failures do
      expect { send_request }.to change(Reading, :count).by(-1)
      expect(turbo_stream_for("remove", "reading_#{reading.id}")).to be_present
    end

    context "with a compilation" do
      let!(:reading) { create_reading(:evil_13, finish: 1.day.ago) }
      let!(:component) do
        create(:reading, user: user, book: create(:book, title: "Buratino"), finish: 2.days.ago,
          compilation_reading: reading)
      end

      it "re-renders the list since the components become standalone readings", :aggregate_failures do
        send_request

        list = turbo_stream_for("replace", "readings_list")
        expect(list.at_css("turbo-frame#reading_#{component.id}")).to be_present
        expect(list.at_css('[data-controller="compilation"]')).to be_nil
      end
    end

    context "with a reading of another user" do
      let!(:reading) { create(:reading, user: create(:user), book: create(:book, :moby_dick)) }

      it "leaves it intact", :aggregate_failures do
        expect { send_request }.not_to change(Reading, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
