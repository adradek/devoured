class WatchingsController < ApplicationController
  def index
    @user     = User.find(params[:user_id])
    @watched  = @user.watched
    @to_watch = @user.intended_films
  end
end
