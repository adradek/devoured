# frozen_string_literal: true

class WatchingPresenter
  include DatesHelper

  attr_reader :watching

  def initialize(watching)
    @watching = watching
  end

  def hint
    "#{watching.days} дней (с #{full_date(watching.start)})" if watching.start
  end

  def dates
    return full_date(finish) unless film.seria
    return '< .. >' unless start || finish
    return "<#{smart_date(start)} - #{smart_date(finish)}>" unless start && finish
    "<#{short_date(start)} - #{smart_date(finish)}>"
  end

  private

  def method_missing(name, *args, &block)
    return watching.public_send(name, *args, &block) if respond_to_missing?(name)
    super
  end

  def respond_to_missing?(name, _include_private = false)
    watching.respond_to?(name)
  end
end
