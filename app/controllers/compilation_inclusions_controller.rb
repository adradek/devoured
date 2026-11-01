# frozen_string_literal: true

class CompilationInclusionsController < ApplicationController
  def new
    @user = current_user
    @reading = current_user.readings.includes(:book).find(params[:reading_id])
    @compilations = current_user.readings.compilations.includes(:book).order(id: :desc)
  end

  def create
    compilation = current_user.readings.compilations.find(inclusion_params[:id])
    reading_to_add = current_user.readings.find(inclusion_params[:reading_id])
    reading_to_add.update!(compilation_reading: compilation)

    respond_to do |format|
      format.turbo_stream do
        @user = current_user
        @readings = ReadingDecorator.collection(UserReadingHistoryDecorator.new(@user).readings)
      end
      format.html { redirect_to user_books_url(current_user) }
    end
  end

  private

  def inclusion_params
    params.require(:compilation_inclusion).permit(:id, :reading_id)
  end
end
