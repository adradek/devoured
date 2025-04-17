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

class Book < ApplicationRecord
  has_many :intents, as: :intended, dependent: :destroy
  has_many :readings, dependent: :destroy

  validates :title, uniqueness: { scope: :author }
  validates :title, presence: true

  # Rubocop said no!
  # puts 'hello world, i\'m testing lefthook gem'

  def caption
    return title if compilation && author.blank?
    %("#{title}", #{author})
  end
end
