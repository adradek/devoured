# frozen_string_literal: true

# Business logic around creation a book
class ReadingCreation
  def self.run(user, book, type, reading_params)
    case type
    when 'consumed' then user.readings.create!(reading_params.merge(book_id: book.id))
    when 'to_read'  then user.intents.create!(intended: book)
    end
  end
end
