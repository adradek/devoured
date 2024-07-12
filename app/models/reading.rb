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
#  compilation            :boolean          default(FALSE)
#  compilation_reading_id :integer
#

class Reading < ApplicationRecord
  scope :in_reverse, -> { order(finish: :desc, id: :desc) }
  scope :compilations, Readings::CompilationsQuery.new

  has_many :components, class_name: 'Reading', foreign_key: 'compilation_reading_id', dependent: :nullify
  belongs_to :compilation_reading, class_name: 'Reading', optional: true
  belongs_to :user
  belongs_to :book

  delegate :compilation, :compilation?, to: :book

  def reading_days
    ((finish || Time.zone.today) - start).to_i if start
  end
end
