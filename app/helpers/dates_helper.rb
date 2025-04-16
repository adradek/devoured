# frozen_string_literal: true

module DatesHelper
  def smart_date(date)
    run_carefully do
      format =
        date.year == Date.current.year ? "%d.%m" : "%d.%m.%y"
      date.strftime(format)
    end
  end

  def short_date(date)
    run_carefully { date.strftime("%d.%m") }
  end

  def full_date(date)
    run_carefully { date.strftime("%d.%m.%y") }
  end

  private

  def run_carefully
    yield
  rescue NoMethodError
    " .. "
  end
end
