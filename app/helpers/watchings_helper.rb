# frozen_string_literal: true

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

    all = film.tomatoes_all
    return '' if all.nil?
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
    first_symbol  = rate.match(/[JQKA.]/).to_s
    second_symbol = special_rates[rate.match(/[HDPCS]/).to_s]

    "#{first_symbol}#{second_symbol}".html_safe
  end

  def special_rates
    @special_rates ||= {
      'H' => content_tag(:span, '♥', class: 'red-card'),
      'D' => content_tag(:span, '♦', class: 'red-card'),
      'P' => content_tag(:span, '♠', class: 'black-card'),
      'C' => content_tag(:span, '♣', class: 'blue-card'),
      'S' => content_tag(:span, '★', class: 'gold-star')
    }.freeze
  end
end
