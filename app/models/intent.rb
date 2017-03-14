class Intent < ApplicationRecord
  belongs_to :user
  belongs_to :intended, polymorphic: true
end
