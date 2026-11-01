# frozen_string_literal: true

module TurboStreamHelpers
  def turbo_stream_headers
    { "Accept" => "#{Mime[:turbo_stream]}, #{Mime[:html]}" }
  end

  def html_body
    Nokogiri::HTML(response.body)
  end

  def turbo_stream_for(action, target)
    html_body.at_css(%(turbo-stream[action="#{action}"][target="#{target}"]))
  end
end
