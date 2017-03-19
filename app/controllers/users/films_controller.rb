class Users::FilmsController < ApplicationController
  before_action :set_user

  def index
    @films_consumed = @user.watched
    @films_to_watch  = @user.intended_films
    @film = Film.new
  end

  def create
    # TODO: find by some global param, maybe IMDB id or Kinopoisk id
    film = Film.create!(film_params)

    case params[:film_type]
    when "consumed" then @user.watchings.create!(film_id: film.id)
    when "to_watch" then @user.intents.create!(intended: film)
    end

    redirect_to user_films_url(@user)
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def film_params
      params.require(:film).permit(:name_eng, :name_rus, :seria, :imdb, :tomatoes)
    end
end
