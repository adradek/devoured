# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/users/:user_secret_id/readings/:reading_id/progresses", type: :request do
  before { login_user(user, password, sessions_path) }

  let!(:user) { create :user, password: password }
  let!(:password) { "12345678" }
  let!(:reading) { create :reading, user: user, total_pages: 397 }

  def entry(from_page, to_page, **attributes)
    create(:reading_progress, reading: reading, from_page: from_page, to_page: to_page, **attributes)
  end

  def frame
    html_body.at_css("turbo-frame#reading_#{reading.id}")
  end

  def field_value(name)
    frame.at_css(%(input[name="reading_progress[#{name}]"]))["value"]
  end

  describe "GET /new" do
    subject(:send_request) { get new_user_reading_progress_path(user, reading) }

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "renders the form inside the reading frame" do
      send_request

      expect(frame.at_css(%(form[action="#{user_reading_progresses_path(user, reading)}"]))).to be_present
    end

    it "shows the number of pages in the book" do
      send_request

      expect(frame.at_css(".total-pages").text).to include("397")
    end

    context "when the reading has no entries yet", :aggregate_failures do
      it "leaves the pages empty and does not offer to start over" do
        send_request

        expect(field_value(:from_page)).to be_nil
        expect(field_value(:to_page)).to be_nil
        expect(frame.at_css("input[name=start_over]")).to be_nil
      end
    end

    context "when the reading has entries" do
      # Created out of order: the latest one is chosen by date, not by creation
      before do
        entry(30, 50, date: 1.day.ago, note: "Глава 3")
        entry(0, 10, date: 3.days.ago, note: "Глава 1")
        entry(10, 30, date: 2.days.ago, note: "Глава 2")
      end

      it "shows the two latest entries" do
        send_request

        expect(frame.css(".recent-progress .progress-note").map(&:text)).to eq ["Глава 3", "Глава 2"]
      end

      it "suggests going on from the last page and leaves the end empty", :aggregate_failures do
        send_request

        expect(field_value(:from_page)).to eq "50"
        expect(field_value(:to_page)).to be_nil
      end

      it "offers to start over" do
        send_request

        expect(frame.at_css("input[name=start_over]")).to be_present
      end
    end

    context "when the reading belongs to another user" do
      let!(:reading) { create :reading }

      it "responds with 404" do
        send_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    subject(:send_request) { post user_reading_progresses_path(user, reading), params: params }

    let(:progress_params) { { date: "2026-11-01", from_page: "0", to_page: "25", note: "Глава 1" } }
    let(:params) { { reading_progress: progress_params } }

    it_behaves_like "authentication needed action"
    it_behaves_like "authorization protected action"

    it "creates an entry" do
      expect { send_request }.to change(reading.progresses, :count).by(1)
    end

    it "saves what was entered" do
      send_request

      expect(reading.progresses.last).to have_attributes(
        date: Date.new(2026, 11, 1), from_page: 0, to_page: 25, note: "Глава 1", attempt: 1
      )
    end

    it "brings the reading card back into the frame", :aggregate_failures do
      send_request

      expect(frame.at_css(".card.reading")).to be_present
      expect(frame.at_css(%(form[action="#{user_reading_progresses_path(user, reading)}"]))).to be_nil
    end

    context "when starting over" do
      let(:params) { { reading_progress: progress_params, start_over: "1" } }

      before { entry(0, 100) }

      it "puts the entry into a new attempt", :aggregate_failures do
        send_request

        expect(reading.reload.attempt).to eq 2
        expect(reading.progresses.last.attempt).to eq 2
      end
    end

    context "when the pages are invalid" do
      let(:progress_params) { { date: "2026-11-01", from_page: "25", to_page: "10" } }

      it "does not create an entry" do
        expect { send_request }.not_to change(ReadingProgress, :count)
      end

      it "renders the form with errors", :aggregate_failures do
        send_request

        expect(response).to have_http_status(:unprocessable_content)
        expect(frame.at_css(".progress-errors")).to be_present
        expect(field_value(:from_page)).to eq "25"
      end
    end

    context "when the reading belongs to another user" do
      let!(:reading) { create :reading }

      it "leaves it intact", :aggregate_failures do
        expect { send_request }.not_to change(ReadingProgress, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
