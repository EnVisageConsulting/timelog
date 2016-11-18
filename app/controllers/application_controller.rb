class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user=(user)
    session[:current_user] = user.is_a?(User) ? user.id : nil
    return user
  end

  def current_user
    @current_user ||= session[:current_user] ? User.find_by(id: session[:current_user]) : nil
  end

  def require_user
    raise NOT_FOUND if current_user.blank?
  end

  def require_admin
    raise NOT_FOUND if !current_user.try(:admin?)
  end
end
