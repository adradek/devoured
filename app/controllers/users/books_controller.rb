# frozen_string_literal: true

module Users
  class BooksController < ApplicationController
    include BookParams

    before_action :set_user

    def index
      @readings = decorated_readings
      @intentions = @user.intents.includes(:intended).where(intended_type: "Book")
      @book = Book.new
    end

    def show
      @reading = @user.readings.includes(:book).find(params[:id])
      render partial: "reading", locals: { reading: ReadingDecorator.new(@reading) }
    end

    def create
      authorize @user, :update?

      book = Book.find_by(book_params.slice(:title, :author)) || Book.create!(book_params)

      # TODO: вообще, это создает баг. При создании reading_intent мы попадаем сюда же
      reading = ReadingCreation.run(@user, book, params[:book_type], reading_params)

      respond_to do |format|
        format.turbo_stream { @reading = ReadingDecorator.new(reading) }
        format.html { redirect_to user_books_url(@user) }
      end
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
        render partial: "reading", locals: { reading: ReadingDecorator.new(@reading) }
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @user, :update?

      @reading = @user.readings.find(params[:id])
      book = @reading.book

      @reading.destroy
      book.destroy if book.readings.empty? && book.intents.empty?

      respond_to do |format|
        # Components of a destroyed compilation become standalone readings, so the whole list is re-rendered
        format.turbo_stream { @readings = decorated_readings if @reading.compilation? }
        format.html { redirect_to user_books_url(@user) }
      end
    end

    private

    def decorated_readings
      ReadingDecorator.collection(UserReadingHistoryDecorator.new(@user).readings)
    end

    def set_user
      @user = User.find_by(secret_id: params[:user_secret_id])
    end

    def reading_params
      params.permit(:start, :finish, :professional, :significant)
    end
  end
end
