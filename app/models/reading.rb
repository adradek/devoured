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
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (user_id => users.id)
#

class Reading < ApplicationRecord
  scope :in_reverse, -> { order(finish: :desc, id: :desc) }
  scope :compilations, -> { Readings::CompilationsQuery.new(all).call }

  has_many :components, class_name: "Reading", foreign_key: "compilation_reading_id", dependent: :nullify
  belongs_to :compilation_reading, class_name: "Reading", optional: true
  belongs_to :user, touch: true
  belongs_to :book
  has_many :progresses, class_name: "ReadingProgress", dependent: :delete_all

  validates :total_pages, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :attempt, numericality: { only_integer: true, greater_than: 0 }

  delegate :compilation, :compilation?, to: :book

  # The latest entry of the current attempt: the reader goes on from its `to_page`.
  # Merged entries keep their `created_at`, so the latest is chosen by `updated_at`.
  def last_progress
    progresses.where(attempt: attempt).latest_first.first
  end

  def reading_days
    ((finish || Time.zone.today) - start).to_i if start
  end
end
