# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string           not null
#  crypted_password :string
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ApplicationRecord
  ADMINS = Rails.application.credentials[:admins]&.split(",")

  before_validation :set_secret_id

  authenticates_with_sorcery!

  has_many :intents, dependent: :destroy
  has_many :intended_books, -> { order("intents.id ASC") }, through: :intents, source: :intended,
              source_type: 'Book'
  has_many :intended_films, -> { order("intents.id ASC") }, through: :intents, source: :intended,
              source_type: 'Film'

  has_many :readings, dependent: :destroy
  has_many :watchings, -> { order(finish: :desc, id: :desc) }, dependent: :destroy
  has_many :watched, through: :watchings,  source: :film

  validates :password, length: { minimum: 6 },       if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,           if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true,  if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  def to_param
    secret_id.parameterize
  end

  def admin?
    ADMINS.present? && ADMINS.include?(email)
  end

  def set_secret_id
    return if secret_id

    loop do
      candidate = [*'0'..'9', *'a'..'h'].sample(16).join

      unless User.where(secret_id: candidate).exists?
        self.secret_id = candidate
        break
      end
    end
  end
end
