# frozen_string_literal: true

class WatchingsController < ApplicationController
  def index
    @user     = User.find_by(secret_id: params[:user_secret_id])
    @watched  = @user.watched
    @to_watch = @user.intended_films
  end
end
