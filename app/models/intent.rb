# frozen_string_literal: true

# == Schema Information
#
# Table name: intents
#
#  id            :integer          not null, primary key
#  intended_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  intended_id   :integer
#  user_id       :integer
#
# Indexes
#
#  index_intents_on_intended_type_and_intended_id  (intended_type,intended_id)
#  index_intents_on_user_id                        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Intent < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :intended, polymorphic: true

  def touch_user
    user.touch
  end
end
