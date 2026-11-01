# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReadingProgressCreation do
  subject(:result) { described_class.run(reading, params, start_over: start_over) }

  let(:reading) { create :reading, total_pages: 397 }
  let(:today) { Date.new(2026, 11, 1) }
  let(:params) { { date: today, from_page: 10, to_page: 25, note: "Глава 2" } }
  let(:start_over) { false }

  around { |example| travel_to(Time.zone.local(2026, 11, 1, 16, 20)) { example.run } }

  def entry(from_page, to_page, entered_at: Time.zone.local(2026, 11, 1, 14, 11), **attributes)
    create(:reading_progress, reading: reading, date: today, from_page: from_page, to_page: to_page,
      created_at: entered_at, **attributes)
  end

  context "when nothing adjoins the new entry" do
    it "creates an entry in the current attempt", :aggregate_failures do
      expect { result }.to change(reading.progresses, :count).by(1)
      expect(result).to be_persisted
      expect(result).to have_attributes(from_page: 10, to_page: 25, attempt: 1, note: "Глава 2")
    end

    it "keeps the note as is" do
      expect(result.note).to eq "Глава 2"
    end
  end

  context "when the entry is invalid" do
    let(:params) { { date: today, from_page: 25, to_page: 10 } }
    let(:start_over) { true }

    it "returns the unsaved entry with errors", :aggregate_failures do
      expect(result).not_to be_persisted
      expect(result.errors).to be_of_kind(:to_page, :greater_than)
    end

    it "does not start a new attempt" do
      expect { result }.not_to(change { reading.reload.attempt })
    end
  end

  context "when starting over" do
    let(:start_over) { true }

    before { entry(0, 10) }

    it "increases the reading's attempt counter" do
      expect { result }.to change { reading.reload.attempt }.from(1).to(2)
    end

    it "puts the entry into the new attempt without merging", :aggregate_failures do
      expect { result }.to change(reading.progresses, :count).by(1)
      expect(result).to have_attributes(from_page: 10, to_page: 25, attempt: 2)
    end
  end

  context "when an entry of the same day ends where the new one starts" do
    let!(:earlier) { entry(0, 10, note: "Глава 1") }

    it "extends that entry instead of creating a new one", :aggregate_failures do
      expect { result }.not_to change(ReadingProgress, :count)
      expect(result).to eq earlier
      expect(result.reload).to have_attributes(from_page: 0, to_page: 25)
    end

    it "glues the notes, marking each with the time it was entered" do
      expect(result.reload.note).to eq "14:11 Глава 1\n\n16:20 Глава 2"
    end
  end

  context "when an entry of the same day starts where the new one ends" do
    before { entry(25, 40) }

    it "merges them" do
      expect(result.reload).to have_attributes(from_page: 10, to_page: 40)
    end
  end

  context "when the new entry bridges two entries" do
    let!(:first) { entry(0, 10, note: "Глава 1") }
    let!(:second) { entry(25, 40, entered_at: Time.zone.local(2026, 11, 1, 15, 0), note: "Глава 3") }

    it "merges all three into the earliest entry", :aggregate_failures do
      expect(result).to eq first
      expect(result.reload).to have_attributes(from_page: 0, to_page: 40)
      expect(ReadingProgress.exists?(second.id)).to be false
    end

    it "glues the notes in the order they were entered" do
      expect(result.reload.note).to eq "14:11 Глава 1\n\n15:00 Глава 3\n\n16:20 Глава 2"
    end
  end

  context "when an adjoining entry belongs to another day" do
    before { entry(0, 10, date: today - 1) }

    it "creates a separate entry" do
      expect { result }.to change(ReadingProgress, :count).by(1)
    end
  end

  context "when an adjoining entry belongs to another attempt" do
    before do
      reading.update!(attempt: 2)
      entry(0, 10, attempt: 1)
    end

    it "creates a separate entry" do
      expect { result }.to change(ReadingProgress, :count).by(1)
    end
  end

  context "when an entry of the same day overlaps the new one" do
    before { entry(0, 12) }

    it "creates a separate entry" do
      expect { result }.to change(ReadingProgress, :count).by(1)
    end
  end

  describe "notes of merged entries" do
    before { entry(0, 10, note: earlier_note) }

    let(:earlier_note) { nil }

    context "when only one of them has a note" do
      it "still marks it with the time" do
        expect(result.reload.note).to eq "16:20 Глава 2"
      end
    end

    context "when none of them has a note" do
      let(:params) { { date: today, from_page: 10, to_page: 25 } }

      it "leaves the note empty" do
        expect(result.reload.note).to be_nil
      end
    end

    context "when the earlier note has already been glued" do
      let(:earlier_note) { "14:11 Глава 1\n\n15:00 Глава 1, конец" }

      it "does not mark it again" do
        expect(result.reload.note).to eq "14:11 Глава 1\n\n15:00 Глава 1, конец\n\n16:20 Глава 2"
      end
    end
  end
end
