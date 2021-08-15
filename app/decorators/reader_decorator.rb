class ReaderDecorator
  def initialize(user)
    @user = user
  end

  def readings
    @readings ||= begin
      result = []

      @user.readings.includes(:book).where(compilation_reading_id: nil).order(finish: :desc, start: :desc).in_reverse.each do |reading|
        result << reading

        if reading.compilation?
          result.concat(reading.components.includes(:book, :compilation_reading).in_reverse)
        end
      end

      result
    end
  end
end
