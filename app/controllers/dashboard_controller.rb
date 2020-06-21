class DashboardController < ApplicationController
  skip_before_action :require_user

  def index
    return redirect_to(login_path) unless current_user
  end
end
