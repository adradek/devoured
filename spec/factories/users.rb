# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  crypted_password :string
#  email            :string           not null
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  secret_id        :string
#
# Indexes
#
#  index_users_on_email      (email) UNIQUE
#  index_users_on_secret_id  (secret_id) UNIQUE
#

FactoryBot.define do
  factory :user do
    email      { Faker::Internet.email }
    password   { "12345678" }
    password_confirmation { password }
  end
end
