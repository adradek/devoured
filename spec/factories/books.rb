# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  author      :string
#  short       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  compilation :boolean          default(FALSE)
#

FactoryBot.define do
  factory :book do
    trait :moby_dick do
      title  { 'Моби дик' }
      author { 'Джек Лондон' }
      short  { false }
      compilation { false }
    end

    trait :evil_13 do
      title  { 'Чертова дюжина' }
      short  { false }
      compilation { true }
    end

    trait :vechera do
      title  { 'Вечера на хуторе близ Диканьки' }
      author { 'Гоголь' }
      short  { false }
      compilation { true }
    end
  end
end
