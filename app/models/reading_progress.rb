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

# See doc/features/reading-progress.md
class ReadingProgress < ApplicationRecord
  belongs_to :reading, touch: true

  scope :latest_first, -> { order(date: :desc, updated_at: :desc, id: :desc) }

  attribute :date, default: -> { Time.zone.today }

  normalizes :note, with: ->(note) { note.strip.presence }

  validates :date, presence: true
  validates :from_page, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :to_page, numericality: { only_integer: true }
  validates :to_page, comparison: { greater_than: :from_page }, allow_nil: true, if: :from_page
  validates :attempt, numericality: { only_integer: true, greater_than: 0 }
end
