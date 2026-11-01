# frozen_string_literal: true

# Adds view layer methods to model
class ReadingDecorator
  attr_reader :reading

  def self.collection(readings)
    readings.map { |r| new(r) }
  end

  def initialize(reading)
    @reading = reading
  end

  def hint
    "#{reading.reading_days} дней (с #{reading.start.strftime('%d.%m.%y')})" if reading.start
  end

  def labels
    @labels ||= [].tap do |arr|
      arr << "short" if reading.book.short
      arr << "profy" if reading.professional
      arr << "significant" if reading.significant
      arr << "unfinished" unless reading.finish
      arr << "compilation" if reading.compilation
      arr << "component" if reading.compilation_reading_id
    end
  end

  def components_collapsed?
    reading.compilation && reading.finish.present?
  end

  # Progress is entered only while the book is being read; compilations have no pages of their own
  def progress_trackable?
    reading.finish.nil? && !reading.compilation
  end

  def finish_date
    reading.finish&.strftime("%d.%m.%y")
  end

  private

  def method_missing(name, *attr, &block)
    return reading.public_send(name, *attr, &block) if respond_to_missing?(name)

    super
  end

  def respond_to_missing?(name, _include_private = false)
    reading.respond_to?(name)
  end
end
