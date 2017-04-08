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
