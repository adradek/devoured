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
    result = []
    result << 'short' if reading.book.short
    result << 'profy' if reading.professional
    result << 'significant' if reading.significant
    result << 'unfinished' unless reading.finish
    add_compilation_labels(result)
    result
  end

  private

  def add_compilation_labels(result)
    if reading.compilation
      result << 'compilation'
    elsif reading.compilation_reading_id
      result << 'component collapse'
      result << 'show' unless reading.compilation_reading.finish
    end
  end

  def method_missing(name, *attr, &block)
    return reading.public_send(name, *attr, &block) if respond_to_missing?(name)

    super
  end

  def respond_to_missing?(name, _include_private = false)
    reading.respond_to?(name)
  end
end
