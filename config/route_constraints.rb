module RouteConstraints
  module UserConstraint
    def current_user(request)
      User.find_by(id: request.session[:user_id])
    end
  end

  class UserRequiredConstraint
    include UserConstraint

    def matches?(request)
      current_user(request).present?
    end
  end
end
