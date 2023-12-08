class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  before_action :require_login

  before_action do
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  private

  def not_authenticated
    redirect_to login_url, alert: "First login to access this page."
  end

  def permission_denied
    head 403
  end
end
