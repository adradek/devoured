# frozen_string_literal: true

# == Schema Information
#
# Table name: readings
#
#  id                     :integer          not null, primary key
#  finish                 :date
#  professional           :boolean          default(FALSE), not null
#  significant            :boolean          default(FALSE)
#  start                  :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  book_id                :integer
#  compilation_reading_id :integer
#  user_id                :integer
#
# Indexes
#
#  index_readings_on_book_id                 (book_id)
#  index_readings_on_compilation_reading_id  (compilation_reading_id)
#  index_readings_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :reading do
  end
end
