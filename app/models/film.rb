class Film < ApplicationRecord
  has_many :intents, as: :intended
end
