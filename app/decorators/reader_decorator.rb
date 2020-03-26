class ReaderDecorator
  def initialize(user)
    @user = user
  end

  def readings
    @readings ||= begin
      result = []
      @user.readings.where(compilation_reading_id: nil).order(finish: :desc, start: :desc).in_reverse.each do |reading|
        result << reading
        result.concat(reading.components.in_reverse) if reading.compilation?
      end
      result
    end
  end
end
