# == Schema Information
#
# Table name: watchings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  film_id    :integer
#  start      :date
#  finish     :date
#  rate       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class WatchingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
