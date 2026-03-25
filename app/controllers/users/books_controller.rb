# frozen_string_literal: true

module Users
  class BooksController < ApplicationController
    include BookParams

    before_action :set_user

    def index
      @user = User.find_by(secret_id: params[:user_secret_id])
      @readings = ReadingDecorator
        .collection(UserReadingHistoryDecorator.new(@user).readings)
      @intentions = @user.intents.includes(:intended).where(intended_type: "Book")
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

    private

    def set_user
      @user = User.find_by(secret_id: params[:user_secret_id])
    end

    def reading_params
      params.permit(:start, :finish, :professional, :significant)
    end
  end
end
