module DatesHelper
  def smart_date(date)
    format =
      date.year == Date.current.year ? '%d.%m' : '%d.%m.%y'
    date.strftime(format)
  rescue
    ' .. '
  end

  def short_date(date)
    date.strftime('%d.%m') rescue ' .. '
  end

  def full_date(date)
    date.strftime('%d.%m.%Y') rescue ' .. '
  end
end
