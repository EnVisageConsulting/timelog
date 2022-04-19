class DashboardController < ApplicationController
  skip_before_action :require_user

  def index
    return redirect_to(login_path) unless current_user
  end

  def create
    respond_to do |format|
      if current_user.update(dashboard_params)
        format.html {redirect_to root_path, notice: "Successfully updated chart!"}
      else
        format.html {redirect_to root_path, alert: "Error updating chart"}
      end
    end
  end

  private

    def dashboard_params
      params.require(:user).permit(:unit_amount, :unit_type, :start_date, :end_date)
    end
end
