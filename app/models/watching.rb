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
  belongs_to :user, touch: true
  belongs_to :film

  def days
    ((finish || Time.zone.today) - start).to_i if start
  end

  private

  def single_month?
    start.month == finish.month && start.year == finish.year
  end
end
