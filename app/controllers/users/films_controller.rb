# frozen_string_literal: true

module Users
  class FilmsController < ApplicationController
    before_action :set_user

    def index
      @watchings = @user.watchings.includes(:film)
      @intentions = @user.intents.includes(:intended).where(intended_type: "Film")
      @film = Film.new
    end

    def create
      authorize @user, :update?
      ::FilmCreation.run(@user, params[:film_type], film_params, watching_params)
      redirect_to user_films_url(@user)
    end

    def edit
      authorize @user, :update?
      @watching = @user.watchings.includes(:film).find(params[:id])
    end

    def update
      authorize @user, :update?
      @watching = @user.watchings.find(params[:id])
      film = @watching.film
      if @watching.update(watching_params) && film.update(film_params)
        redirect_to user_films_url
      else
        render :edit
      end
    end

    def destroy
      authorize @user, :update?
      watching = Watching.find(params[:id])
      film = watching.film
      watching.destroy
      film.destroy if film.watchings.empty? && film.intents.empty?
      redirect_to user_films_url(params[:user_secret_id])
    end

    def destroy_intents
      authorize @user, :update?
      Intent.where(user_id: params[:user_secret_id], intended_type: 'Film', intended_id: params[:id]).destroy_all
      redirect_to user_films_url(params[:user_secret_id])
    end

    private

    def set_user
      @user = User.find_by(secret_id: params[:user_secret_id])
    end

    def film_params
      params.require(:film).permit(:name_eng, :name_rus, :seria, :imdb, :tomatoes)
    end

    def watching_params
      params.permit(:rate, :start, :finish)
    end
  end
end
