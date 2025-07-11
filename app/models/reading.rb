# frozen_string_literal: true

# == Schema Information
#
# Table name: readings
#
#  id                     :integer          not null, primary key
#  finish                 :date
#  professional           :boolean          default(FALSE), not null
#  significant            :boolean          default(FALSE)
#  start                  :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  book_id                :integer
#  compilation_reading_id :integer
#  user_id                :integer
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
  scope :compilations, Readings::CompilationsQuery.new

  has_many :components, class_name: "Reading", foreign_key: "compilation_reading_id", dependent: :nullify
  belongs_to :compilation_reading, class_name: "Reading", optional: true
  belongs_to :user, touch: true
  belongs_to :book

  delegate :compilation, :compilation?, to: :book

  def reading_days
    ((finish || Time.zone.today) - start).to_i if start
  end
end
