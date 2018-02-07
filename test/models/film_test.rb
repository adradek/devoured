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

require 'test_helper'

class FilmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
