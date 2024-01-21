# frozen_string_literal: true

class CompilationInclusionsController < ApplicationController
  def create
    compilation = Reading.find(inclusion_params[:id])
    reading = Reading.find(inclusion_params[:reading_id])

    reading.update!(compilation_reading: compilation)
    redirect_to user_books_url(reading.user)
  end

  private

  def inclusion_params
    params.require(:compilation_inclusion).permit(:id, :reading_id)
  end
end
