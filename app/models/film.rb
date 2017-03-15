class Film < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy

  def name
    name_rus.present? ? name_rus : name_eng
  end
end
