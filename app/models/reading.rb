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

  has_many :components, class_name: 'Reading', foreign_key: 'compilation_reading_id'
  belongs_to :compilation_reading, class_name: 'Reading', optional: true
  belongs_to :user
  belongs_to :book

  def reading_days
    ((finish || Time.zone.today) - start).to_i if start
  end

  def hint
    "#{reading_days} дней (с #{start.strftime('%d.%m.%y')})" if start
  end

  def labels
    result = []
    result << "short" if book.short
    result << "profy" if professional
    result << 'significant' if significant
    result << 'compilation' if compilation
    if compilation_reading_id
      result << 'component collapse'
      result << 'show' unless compilation_reading.finish
    end
    result << 'unfinished' if finish.nil?
    result
  end
end
