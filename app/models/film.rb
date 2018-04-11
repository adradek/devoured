# == Schema Information
#
# Table name: films
#
#  id         :integer          not null, primary key
#  name_rus   :string
#  name_eng   :string
#  seria      :boolean          default(FALSE), not null
#  imdb       :integer
#  tomatoes   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Film < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy
  has_many :watchings

  def name
    n = name_rus.present? ? name_rus : name_eng
    seria ? "< #{n} >" : n
  end
end
