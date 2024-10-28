# frozen_string_literal: true

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

class Intent < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :intended, polymorphic: true

  def touch_user
    user.touch
  end
end
