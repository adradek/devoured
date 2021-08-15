module WatchingsHelper
  def critics(film)
    output = []
    imdb = film.imdb? ? "#{film.imdb / 10.0} " : ''
    output << content_tag(:span, imdb, class: 'imdb-value')
    output << tomatoes(film)
    output.join.html_safe
  end

  def tomatoes(film)
    output = ["("]
    return '' if film.tomatoes.blank?

    all = film.tomatoes_all
    output << content_tag(:span, all, class: tomatoclass(all))

    top = film.tomatoes_top
    output << content_tag(:span, "-#{top}", class: tomatoclass(top)) if top
    output << ")"

    output.join
  end

  def tomatoclass(rate)
    rate > 60 ? 'fresh-tomato' : 'rotten-tomato'
  end

  def user_rate(rate)
    first_symbol = rate.match(/[JQKA.]/).to_s
    second_symbol =
      case rate.match(/[HDPS]/).to_s
      when 'H' then content_tag(:span, '♥', class: 'red-card')
      when 'D' then content_tag(:span, '♦', class: 'red-card')
      when 'P' then content_tag(:span, '♠', class: 'black-card')
      when 'S' then content_tag(:span, '★', class: 'gold-star')
      else ''
      end

    "#{first_symbol}#{second_symbol}".html_safe
  end
end
