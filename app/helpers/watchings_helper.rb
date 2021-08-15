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
end
