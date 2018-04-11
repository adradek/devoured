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
  belongs_to :user
  belongs_to :film

  def dates
    return finish unless film.seria
    return "< .. >" unless start || finish
    return "<#{start || " .."} - #{finish || ".. "}>" unless start && finish
    if film.seria
      "< - >"
    end
  end

  private

    def single_month?

      start.month == finish
      # если один - вернуть отточия
      # eсли
    end
end
