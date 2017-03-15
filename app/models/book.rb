class Book < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy

  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true
end
