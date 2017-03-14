class Book < ApplicationRecord
  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true
end
