# frozen_string_literal: true

# == Schema Information
#
# Table name: watchings
#
#  id         :integer          not null, primary key
#  finish     :date
#  rate       :string
#  start      :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  film_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_watchings_on_film_id  (film_id)
#  index_watchings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (film_id => films.id)
#  fk_rails_...  (user_id => users.id)
#

class Watching < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :film

  def days
    ((finish || Time.zone.today) - start).to_i if start
  end

  private

  def single_month?
    start.month == finish.month && start.year == finish.year
  end
end
