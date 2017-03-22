class Users::BooksController < ApplicationController
  before_action :set_user, only: [:create]

  def index
    @user = User.includes(readings: :book).find(params[:user_id])
    @book = Book.new
  end

  def create
    book = Book.find_by(book_params.slice(:title, :author)) || Book.create!(book_params)

    if params[:book_type] == "consumed"
      @user.readings.create!(book_id: book.id)
    elsif params[:book_type] == "to_read"
      @user.intents.create!(intended: book)
    end

    redirect_to user_books_url(@user)
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
      params.require(:book).permit(:title, :author, :short)
    end
end
