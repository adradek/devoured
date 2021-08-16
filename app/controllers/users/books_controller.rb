class Users::BooksController < ApplicationController
  before_action :set_user

  def index
    @user = User.find(params[:user_id])
    @readings = ReaderDecorator.new(@user).readings
    @book = Book.new
  end

  def create
    authorize @user, :update?
    book = Book.find_by(book_params.slice(:title, :author)) \
          || Book.create!(book_params.merge(compilation: params[:compilation]))

    case params[:book_type]
    when "consumed" then @user.readings.create!(reading_params.merge("book_id" => book.id))
    when "to_read"  then @user.intents.create!(intended: book)
    end

    redirect_to user_books_url(@user)
  end

  # You can edit your readings, not intents
  # params[:id] - id of reading, not book
  #
  def edit
    @reading = @user.readings.includes(:book).find(params[:id])
  end

  def update
    @reading = @user.readings.find(params[:id])
    if @reading.update(reading_params)
      redirect_to user_books_url
    else
      render :edit
    end
  end

  def destroy
    reading = Reading.find(params[:id])
    book    = reading.book
    reading.destroy
    book.destroy if book.readings.empty? && book.intents.empty?
    redirect_to user_books_url params[:user_id]
  end

  def destroy_intents
    Intent.where(user_id: params[:user_id], intended_type: 'Book', intended_id: params[:id])
          .destroy_all
    redirect_to user_books_url(params[:user_id])
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :short, :compilation)
    end

    def reading_params
      params.permit(:start, :finish, :professional, :significant, :compilation)
    end
end
