class Book < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy
  has_many :readings

  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true

  def caption
    [%W("#{title}"), author].compact.join(", ")
  end
end
