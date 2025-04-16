# frozen_string_literal: true

module Users
  class BooksController < ApplicationController
    before_action :set_user

    caches_action :index, expires_in: 3.days, cache_path: -> do
      lrt = Reading.where(user_id: current_user.id).order(updated_at: :desc).first.updated_at.to_i
      user_books_url(current_user, lrt: lrt)
    end

    def index
      @user = User.find_by(secret_id: params[:user_secret_id])
      @readings = ReadingDecorator.collection(ReaderDecorator.new(@user).readings)
      @book = Book.new
    end

    def create
      authorize @user, :update?

      book = Book.find_by(book_params.slice(:title, :author)) || Book.create!(book_params)
      ReadingCreation.run(@user, book, params[:book_type], reading_params)
      redirect_to user_books_url(@user)
    end

    # You can edit your readings, not intents
    # params[:id] - id of the reading, not book
    #
    def edit
      authorize @user, :update?
      @reading = @user.readings.includes(:book).find(params[:id])
    end

    def update
      authorize @user, :update?
      @reading = @user.readings.find(params[:id])
      if @reading.update(reading_params)
        redirect_to user_books_url
      else
        render :edit
      end
    end

    def destroy
      authorize @user, :update?
      reading = Reading.find(params[:id])
      book    = reading.book
      reading.destroy
      book.destroy if book.readings.empty? && book.intents.empty?
      redirect_to user_books_url(params[:user_secret_id])
    end

    def destroy_intents
      authorize @user, :update?
      Intent.where(user_id: params[:user_secret_id], intended_type: "Book", intended_id: params[:id])
            .destroy_all
      redirect_to user_books_url(params[:user_secret_id])
    end

    private

    def set_user
      @user = User.find_by(secret_id: params[:user_secret_id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :short, :compilation)
    end

    def reading_params
      params.permit(:start, :finish, :professional, :significant)
    end
  end
end
