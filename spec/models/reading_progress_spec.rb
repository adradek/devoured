# frozen_string_literal: true

# == Schema Information
#
# Table name: reading_progresses
#
#  id         :integer          not null, primary key
#  reading_id :integer          not null
#  date       :date             not null
#  from_page  :integer          not null
#  to_page    :integer          not null
#  attempt    :integer          not null
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reading_progresses_on_reading_id_and_attempt_and_date  (reading_id,attempt,date)
#

require "rails_helper"

RSpec.describe ReadingProgress do
  subject(:progress) { build :reading_progress, reading: reading, from_page: from_page, to_page: to_page }

  let(:reading) { create :reading, total_pages: total_pages }
  let(:total_pages) { 397 }
  let(:from_page) { 0 }
  let(:to_page) { 10 }

  it { is_expected.to be_valid }

  it "takes today as the default date" do
    expect(described_class.new.date).to eq Time.zone.today
  end

  it "requires a date" do
    progress.date = nil

    expect(progress).not_to be_valid
  end

  it "requires a positive attempt" do
    progress.attempt = 0

    expect(progress).not_to be_valid
  end

  it "stores a blank note as nil" do
    progress.note = "  \n "

    expect(progress.note).to be_nil
  end

  it "touches the reading" do
    expect { progress.save! }.to(change { reading.reload.updated_at })
  end

  context "when a page is missing" do
    let(:to_page) { nil }

    it { is_expected.not_to be_valid }
  end

  context "when a page is not an integer" do
    let(:to_page) { "10.5" }

    it { is_expected.not_to be_valid }
  end

  context "when from_page is negative" do
    let(:from_page) { -1 }

    it { is_expected.not_to be_valid }
  end

  context "when to_page equals from_page" do
    let(:to_page) { from_page }

    it { is_expected.not_to be_valid }
  end

  context "when to_page is before from_page" do
    let(:from_page) { 20 }

    it { is_expected.not_to be_valid }
  end

  context "when to_page is the end of the book" do
    let(:to_page) { total_pages }

    it { is_expected.to be_valid }
  end

  context "when the number of pages in the book is unknown" do
    let(:total_pages) { nil }
    let(:to_page) { 10_000 }

    it { is_expected.to be_valid }
  end
end
