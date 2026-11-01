# frozen_string_literal: true

# == Schema Information
#
# Table name: reading_progresses
#
#  id         :integer          not null, primary key
#  reading_id :integer          not null
#  date       :date             not null
#  from_page  :integer          not null
#  to_page    :integer          not null
#  attempt    :integer          not null
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reading_progresses_on_reading_id_and_attempt_and_date  (reading_id,attempt,date)
#

FactoryBot.define do
  factory :reading_progress do
    reading
    date { Time.zone.today }
    from_page { 0 }
    to_page { 10 }
    attempt { 1 }
  end
end
