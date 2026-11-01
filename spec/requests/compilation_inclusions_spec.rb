# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/compilation_inclusions", type: :request do
  before { login_user(user, password, sessions_path) }

  let!(:user) { create :user, password: }
  let!(:password) { "12345678" }
  let(:other_user) { create(:user) }

  let!(:reading) { create(:reading, user: user, book: create(:book, :moby_dick)) }
  let!(:compilation) { create(:reading, user:, book: create(:book, :evil_13)) }
  let!(:foreign_compilation) { create(:reading, user: other_user, book: create(:book, :mirgorod)) }

  describe "GET /new" do
    subject(:send_request) { get new_compilation_inclusion_path(reading_id: reading.id) }

    it_behaves_like "authentication needed action"

    it "renders the form inside the reading frame" do
      send_request

      expect(html_body.at_css("turbo-frame#reading_#{reading.id} form")).to be_present
    end

    it "offers only the user's own compilations", :aggregate_failures do
      send_request

      options = html_body.css("select option").map(&:text)
      expect(options).to include(compilation.book.caption)
      expect(options).not_to include(foreign_compilation.book.caption)
    end

    context "with a reading of another user" do
      let!(:reading) { create(:reading, user: other_user, book: create(:book, :moby_dick)) }

      it "responds with 404" do
        send_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    subject(:send_request) do
      post compilation_inclusions_path,
        params: { compilation_inclusion: { id: compilation_id, reading_id: reading.id } },
        headers: turbo_stream_headers
    end

    let(:compilation_id) { compilation.id }

    it_behaves_like "authentication needed action"

    it "puts the reading into the compilation" do
      send_request

      expect(reading.reload.compilation_reading).to eq(compilation)
    end

    it "re-renders the readings list" do
      send_request

      list = turbo_stream_for("replace", "readings_list")
      expect(list.at_css("[data-compilation-target='components'] turbo-frame#reading_#{reading.id}")).to be_present
    end

    context "with a compilation of another user" do
      let(:compilation_id) { foreign_compilation.id }

      it "leaves the reading intact", :aggregate_failures do
        send_request

        expect(response).to have_http_status(:not_found)
        expect(reading.reload.compilation_reading).to be_nil
      end
    end
  end
end
