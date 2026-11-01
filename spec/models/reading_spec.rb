# frozen_string_literal: true

# == Schema Information
#
# Table name: readings
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  book_id                :integer
#  start                  :date
#  finish                 :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  professional           :boolean          default(FALSE), not null
#  significant            :boolean          default(FALSE)
#  compilation_reading_id :integer
#  total_pages            :integer
#  attempt                :integer          default(1), not null
#
# Indexes
#
#  index_readings_on_book_id                 (book_id)
#  index_readings_on_compilation_reading_id  (compilation_reading_id)
#  index_readings_on_user_id                 (user_id)
#

require "rails_helper"

RSpec.describe Reading do
  let(:user) { create :user }

  let(:moby_dick) { create :book, :moby_dick }
  let(:evil_13) { create :book, :evil_13 }
  let(:vechera) { create :book, :vechera }
  let(:mirgorod) { create :book, :mirgorod }

  describe "validations" do
    subject(:reading) { build :reading }

    it "starts with the first attempt" do
      expect(reading.attempt).to eq 1
    end

    it "allows the number of pages to be unknown" do
      reading.total_pages = nil

      expect(reading).to be_valid
    end

    it "requires a positive number of pages" do
      reading.total_pages = 0

      expect(reading).not_to be_valid
    end

    it "requires a positive attempt" do
      reading.attempt = 0

      expect(reading).not_to be_valid
    end
  end

  describe "compilations scope" do
    let(:other_user) { create :user }
    let(:compilation_readings) { user.readings.compilations }

    before do
      described_class.create!(user: user, book: moby_dick)
      described_class.create!(user: user, book: evil_13)    # is compilation
      described_class.create!(user: user, book: vechera)    # is compilation
      described_class.create!(user: other_user, book: mirgorod) # is compilation, but read by another user
    end

    it "returns all compilations" do
      expect(compilation_readings.map { it.book.title }).to match_array([evil_13, vechera].map(&:title))
    end

    it "ignores other books" do
      expect(compilation_readings.map { it.book.title }).not_to include(moby_dick.title)
    end

    context "when called on a relation filtered by user" do
      let(:specified_readings) { described_class.where(user: user).compilations }

      it "doesn't contain compilation readings by another user" do
        expect(specified_readings.map { it.book.title }).not_to include(mirgorod.title)
      end
    end
  end
end
