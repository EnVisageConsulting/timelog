class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_user

  helper_method :current_user
  helper_method :current_log

  def current_user=(user)
    session[:current_user] = user.is_a?(User) ? user.id : nil
    return user
  end

  def current_user
    @current_user ||= session[:current_user] ? User.find_by(id: session[:current_user]) : nil
  end

  def current_log
    @current_log ||= current_user.current_log if current_user
  end

  def require_user
    no_access if current_user.blank?
  end

  def require_admin
    no_access if !current_user.try(:admin?)
  end

   def require_admin_or_partner
    no_access unless current_user&.admin? || current_user&.partner?
   end

  def not_found
    respond_to do |format|
      format.json { head :not_found }
      format.html { redirect_to root_url, :alert => "Page Not Found" }
    end
  end

  def no_access
    respond_to do |format|
      format.json { head :no_access }
      format.html { redirect_to root_url, :alert => "You are not authorized to access this page." }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, :alert => exception.message }
    end
  end
end
