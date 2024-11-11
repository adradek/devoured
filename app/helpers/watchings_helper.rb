# frozen_string_literal: true

module WatchingsHelper
  _tagger = Object.new.extend(::ActionView::Helpers::TagHelper)

  SPECIAL_RATES ||= {
      'H' => _tagger.content_tag(:span, '♥', class: 'red-card'),
      'D' => _tagger.content_tag(:span, '♦', class: 'red-card'),
      'P' => _tagger.content_tag(:span, '♠', class: 'black-card'),
      'C' => _tagger.content_tag(:span, '♣', class: 'blue-card'),
      'S' => _tagger.content_tag(:span, '★', class: 'gold-star')
  }.freeze

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
    other_symbols = rate.match(/[HDPCS]+/).to_s.split("").map { |c| SPECIAL_RATES[c] }

    "#{first_symbol}#{other_symbols.join}".html_safe
  end
end
