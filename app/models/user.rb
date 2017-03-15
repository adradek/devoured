class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :intents, dependent: :destroy
  has_many :intended_books, through: :intents, source: :intended, source_type: 'Book'
  has_many :intended_films, through: :intents, source: :intended, source_type: 'Film'

  has_many :readings,  dependent: :destroy
  has_many :watchings, dependent: :destroy
  has_many :read,    through: :readings,   source: :book
  has_many :watched, through: :watchings,  source: :film

  validates :password, length: { minimum: 6 },       if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,           if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true,  if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
end
