# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  before_action :require_login
  before_action { Rack::MiniProfiler.authorize_request if current_user&.is_admin? }

  private

  def not_authenticated
    redirect_to login_url, alert: "First login to access this page."
  end

  def permission_denied
    head 403
  end
end
