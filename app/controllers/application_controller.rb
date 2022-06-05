class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  before_action :require_login

  private

  def not_authenticated
    redirect_to login_url, alert: "First login to access this page."
  end

  def permission_denied
    head 403
  end
end
