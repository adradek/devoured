# frozen_string_literal: true

# == Schema Information
#
# Table name: watchings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  film_id    :integer
#  start      :date
#  finish     :date
#  rate       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Watching < ApplicationRecord
  include DatesHelper

  belongs_to :user
  belongs_to :film

  def dates
    return full_date(finish) unless film.seria
    return "< .. >" unless start || finish
    return "<#{smart_date(start)} - #{smart_date(finish)}>" unless start && finish
    "<#{short_date(start)} - #{smart_date(finish)}>"
  end

  private

  def single_month?
    start.month == finish.month && start.year == finish.year
  end
end
