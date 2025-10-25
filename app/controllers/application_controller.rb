# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  before_action :require_login
  # before_action { Rack::MiniProfiler.authorize_request if current_user&.admin? }

  private

  def not_authenticated
    redirect_to login_url, alert: "First login to access this page."
  end

  def permission_denied
    head :forbidden
  end
end
