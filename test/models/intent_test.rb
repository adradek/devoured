# == Schema Information
#
# Table name: intents
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  intended_type :string
#  intended_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class IntentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
