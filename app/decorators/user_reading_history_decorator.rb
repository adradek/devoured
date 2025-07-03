# frozen_string_literal: true

# Decorator for displaying a user's reading history in chronological order.
# Handles both individual readings and compilation readings (groups of related readings).
class UserReadingHistoryDecorator
  def initialize(user)
    @user = user
  end

  # Returns a flattened list of readings ordered by finish date.
  # For compilation readings, includes their components immediately after.
  # @return [Array<Reading>]
  def readings
    @readings ||= fetch_readings
  end

  private

  def fetch_readings
    result = []
    main_readings = fetch_main_readings

    main_readings.each do |reading|
      result << reading
      result.concat(fetch_components(reading)) if reading.compilation?
    end

    result
  end

  def fetch_main_readings
    @user
      .readings
      .includes(:book)
      .where(compilation_reading_id: nil)
      .in_reverse
  end

  def fetch_components(reading)
    reading
      .components
      .includes(:book, :compilation_reading)
      .in_reverse
  end
end
