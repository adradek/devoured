task parse_tomatoes: :environment do
  puts "Hello"
  Film.all.each do |film|
    puts "Film: #{film.name_rus} - tomatoes: #{film.tomatoes}\n"
    next if film.tomatoes.blank?
    rates = film.tomatoes.match(/(\d{2,3})-?(\d{2,3})?/)
    next if rates.nil?
    puts "parsed rates: #{rates.inspect}\n\n"
    film.tomatoes_all = rates[1]
    film.tomatoes_top = rates[2]
    film.save!
  end
end
