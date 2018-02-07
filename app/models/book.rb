# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  author     :string
#  short      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy
  has_many :readings

  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true

  def caption
    [%W("#{title}"), author].compact.join(", ")
  end
end
