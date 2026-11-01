# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReadingProgressMap do
  subject(:map) { described_class.new(reading) }

  let(:reading) { create :reading, total_pages: total_pages }
  let(:total_pages) { 397 }
  let(:bar) { map.bars.first }

  def entry(from_page, to_page, date: Date.new(2026, 10, 1), **attributes)
    create(:reading_progress, reading: reading, from_page: from_page, to_page: to_page, date: date, **attributes)
  end

  describe "a segment" do
    before { entry(0, 10, note: "Глава 1") }

    let(:segment) { bar.segments.first }

    it "is placed by percent of the book" do
      expect(segment).to have_attributes(left: 0.0, width: 2.519)
    end

    it "describes the entry in a hint" do
      expect(segment.hint).to eq "01.10.26 · с 0 по 10 · 10 стр.\nГлава 1"
    end

    it "is summarized with the share of the book" do
      expect(bar.summary).to eq "прочитано 10 из 397 стр. (3%)"
    end
  end

  context "when pages are re-read" do
    before do
      entry(0, 60)
      entry(40, 80, date: Date.new(2026, 10, 2))
    end

    it "counts them once" do
      expect(bar).to have_attributes(pages_read: 80, percent: 20)
    end

    it "keeps both segments, the later one drawn on top" do
      expect(bar.segments.map(&:left)).to eq [0.0, 10.076]
    end
  end

  context "when an entry goes beyond the end of the book" do
    before do
      entry(390, 420)
      entry(400, 410)
    end

    it "cuts it off at the end of the bar", :aggregate_failures do
      expect(bar.segments.size).to eq 1
      expect(bar.segments.first.left + bar.segments.first.width).to be_within(0.001).of(100)
    end

    it "does not count pages beyond the end" do
      expect(bar.pages_read).to eq 7
    end
  end

  context "with several attempts" do
    before do
      entry(0, 100, attempt: 1)
      entry(50, 70, attempt: 2, date: Date.new(2026, 10, 20))
      entry(70, 90, attempt: 2, date: Date.new(2026, 10, 21))
    end

    it "makes a bar for each attempt, the current one last", :aggregate_failures do
      expect(map.bars.map(&:attempt)).to eq [1, 2]
      expect(map.bars.map(&:current)).to eq [false, true]
      expect(map).to be_multiple_attempts
    end

    it "shows the dates of each attempt" do
      expect(map.bars.map(&:dates)).to eq ["01.10.26", "20.10.26 – 21.10.26"]
    end
  end

  context "when the number of pages is unknown" do
    let(:total_pages) { nil }

    before do
      entry(0, 60)
      entry(40, 80)
    end

    it "has no segments" do
      expect(bar.segments).to be_empty
    end

    it "tells only the number of pages read" do
      expect(bar.summary).to eq "прочитано 80 стр."
    end
  end

  describe "day colors" do
    before do
      entry(0, 10)
      entry(10, 20) # the same day
      (2..8).each { |day| entry(day * 10, (day * 10) + 10, date: Date.new(2026, 10, day)) }
    end

    let(:colors) { bar.segments.map(&:color) }

    it "are taken from the palette" do
      expect(colors).to all(be_between(0, described_class::PALETTE_SIZE - 1))
    end

    it "are the same within a day" do
      expect(colors[0]).to eq colors[1]
    end

    it "differ from the previous day" do
      expect(colors.drop(1).each_cons(2)).to all(satisfy { |previous, color| previous != color })
    end

    it "stay the same between page loads" do
      expect(described_class.new(reading.reload).bars.first.segments.map(&:color)).to eq colors
    end
  end
end
