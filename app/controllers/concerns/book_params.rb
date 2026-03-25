# frozen_string_literal: true

module BookParams
  private

  def book_params
    params.require(:book).permit(:title, :author, :short, :compilation)
  end
end
