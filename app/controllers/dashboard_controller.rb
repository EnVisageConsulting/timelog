class DashboardController < ApplicationController
  def index
    return redirect_to(login_path) unless current_user
  end
end
