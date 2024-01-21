# frozen_string_literal: true

task parse_tomatoes: :environment do
  puts "Hello"
  Film.all.each do |film|
    film.valid?  # initiates the auto update of the _top and _all fields
    film.save!
  end
end
