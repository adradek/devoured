# frozen_string_literal: true

module Readings
  class CompilationsQuery
    def initialize(relation = ::Reading.all)
      @relation = relation
    end

    def call
      @relation.joins(:book).where(books: { compilation: true })
    end
  end
end
