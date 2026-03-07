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
# Indexes
#
#  index_intents_on_intended_type_and_intended_id  (intended_type,intended_id)
#  index_intents_on_user_id                        (user_id)
#

class Intent < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :intended, polymorphic: true

  def touch_user
    user.touch
  end
end
