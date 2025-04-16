# == Schema Information
#
# Table name: readings
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  book_id                :integer
#  start                  :date
#  finish                 :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  professional           :boolean          default(FALSE), not null
#  significant            :boolean          default(FALSE)
#  compilation            :boolean          default(FALSE)
#  compilation_reading_id :integer
#

require "test_helper"

class ReadingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
