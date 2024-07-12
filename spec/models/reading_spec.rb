# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reading do
  let(:user) { create :user }

  let(:moby_dick) { create :book, :moby_dick }
  let(:evil_13) { create :book, :evil_13 }
  let(:vechera) { create :book, :vechera }

  describe 'compilations scope' do
    before do
      Reading.create!(user: user, book: moby_dick)
      Reading.create!(user: user, book: evil_13)
      Reading.create!(user: user, book: vechera)
    end

    let(:readings) { user.readings.compilations }

    it 'returns all compilations' do
      expect(readings.map { _1.book.title }).to match_array([evil_13, vechera].map(&:title))
    end

    it 'ignores other books' do
      expect(readings.map { _1.book.title }).not_to include(moby_dick.title)
    end
  end
end
