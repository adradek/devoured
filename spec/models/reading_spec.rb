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

  describe "compilations scope" do
    before do
      described_class.create!(user: user, book: moby_dick)
      described_class.create!(user: user, book: evil_13)
      described_class.create!(user: user, book: vechera)
    end

    let(:readings) { user.readings.compilations }

    it "returns all compilations" do
      expect(readings.map { _1.book.title }).to match_array([evil_13, vechera].map(&:title))
    end

    it "ignores other books" do
      expect(readings.map { _1.book.title }).not_to include(moby_dick.title)
    end
  end
end
