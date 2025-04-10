# frozen_string_literal: true

# Business logic from FilmsController
class FilmCreation
  # TODO: find rates by some global param, maybe IMDB id or Kinopoisk id
  def self.run(user, type, film_params, watching_params)
    film = Film.create!(film_params)

    case type
    when 'consumed'
      watching = user.watchings.build(film_id: film.id)
      watching.assign_attributes(watching_params)
      watching.save!
    when 'to_watch'
      user.intents.create!(intended: film)
    end
  end
end
