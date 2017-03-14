class Book < ApplicationRecord
  has_many :intents, as: :intended

  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true
end
