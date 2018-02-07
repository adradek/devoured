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
  belongs_to :user
  belongs_to :intended, polymorphic: true
end
