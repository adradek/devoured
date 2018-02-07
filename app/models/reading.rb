# == Schema Information
#
# Table name: readings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  book_id      :integer
#  start        :date
#  finish       :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  professional :boolean          default(FALSE), not null
#  significant  :boolean          default(FALSE)
#

class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :book

  def reading_days
    ((finish || Time.zone.today) - start).to_i if start
  end

  def hint
    "#{reading_days} дней (с #{start.strftime('%d.%m.%y')})" if start
  end
end
