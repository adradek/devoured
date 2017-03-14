class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :intents
  has_many :intended_books, through: :intents, source: :intended, source_type: 'Book'
  has_many :intended_films, through: :intents, source: :intended, source_type: 'Film'

  validates :password, length: { minimum: 6 },       if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,           if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true,  if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
end
