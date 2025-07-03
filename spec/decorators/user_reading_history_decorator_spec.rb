# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserReadingHistoryDecorator do
  subject(:decorator) { described_class.new(user) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:buratino) { create(:book, title: "Buratino") }
  let(:war_and_piece) { create(:book, title: "War and Piece") }
  let(:anna_karenina) { create(:book, title: "Anna Karenina") }

  describe "#readings" do
    let!(:easy_reading) do
      create(:reading, user: user, book: buratino, start: 1.week.ago, finish: 3.days.ago)
    end

    let!(:hard_reading) do
      create(:reading, user: user, book: war_and_piece, start: 2.weeks.ago, finish: 1.week.ago)
    end

    context "with regular readings" do
      it "returns readings in reverse chronological order" do
        expect(decorator.readings).to eq([easy_reading, hard_reading])
      end

      it "includes associated books" do
        expect(decorator.readings.first.association(:book).loaded?).to be true
      end
    end

    context "with compilation readings" do
      let!(:compilation) do
        create(:reading,
          user: user,
          book: create(:book, title: "Tolsoy Antology", compilation: true),
          start: 3.weeks.ago,
          finish: 2.weeks.ago)
      end

      before do
        easy_reading.update!(compilation_reading: compilation)
        hard_reading.update!(compilation_reading: compilation)
      end

      it "includes compilation and its components" do
        result = decorator.readings
        expect(result).to include(compilation, easy_reading, hard_reading)
      end

      it "places components immediately after their compilation" do
        result = decorator.readings
        compilation_index = result.index(compilation)
        expect(result[compilation_index + 1, 2]).to eq([easy_reading, hard_reading])
      end

      it "loads all the associated books" do
        result = decorator.readings
        expect(result.map { |r| r.association(:book).loaded? }).to all(be true)
      end
    end

    context "with other users readings" do
      let!(:other_reading) do
        create(:reading,
          user: other_user,
          book: buratino,
          start: 1.week.ago,
          finish: 3.days.ago)
      end

      it "only includes readings for the specified user" do
        expect(decorator.readings).not_to include(other_reading)
      end
    end

    # rubocop:disable RSpec/MessageSpies
    it "memoizes the result" do
      expect(user.readings).to receive(:includes).once.and_call_original
      2.times { decorator.readings }
    end
    # rubocop:enable RSpec/MessageSpies
  end
end
