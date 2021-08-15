module WatchingsHelper
  def critics(film)
    imdb = film.imdb? ? (film.imdb / 10.0).to_s : ''
    content_tag(:span, imdb, class: 'imdb-value')
  end
end
