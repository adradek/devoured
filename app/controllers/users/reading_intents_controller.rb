# frozen_string_literal: true

module Users
  class ReadingIntentsController < ApplicationController
    include BookParams

    before_action :set_user

    def create
      authorize @user, :update?

      book = Book.find_by(book_params.slice(:title, :author)) || Book.create!(book_params)
      @intention = @user.intents.create!(intended: book)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_books_url(@user) }
      end
    end

    def destroy
      authorize @user, :update?

      @intent = Intent.find_by!(user_id: @user.id, intended_type: "Book", id: params[:id]).destroy!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_books_url(params[:user_secret_id]) }
      end
    end

    private

    def set_user
      @user = User.find_by(secret_id: params[:user_secret_id])
    end
  end
end
