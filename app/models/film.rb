# frozen_string_literal: true

# == Schema Information
#
# Table name: films
#
#  id           :integer          not null, primary key
#  name_rus     :string
#  name_eng     :string
#  seria        :boolean          default(FALSE), not null
#  imdb         :integer
#  tomatoes     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tomatoes_top :integer
#  tomatoes_all :integer
#

class Film < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy
  has_many :watchings, dependent: :destroy

  before_validation :update_tomatoes_fields

  def name
    n = name_rus.presence || name_eng
    seria ? "< #{n} >" : n
  end

  private

  def update_tomatoes_fields
    return if tomatoes.blank?
    rates = tomatoes.match(/(\d{2,3})-?(\d{2,3})?/)
    return if rates.nil?
    self.tomatoes_all = rates[1]
    self.tomatoes_top = rates[2]
  end
end
