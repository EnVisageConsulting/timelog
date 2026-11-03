class DashboardController < ApplicationController
  skip_before_action :require_user

  def index
    if params[:display_chart].present? &&
        permitted_display_charts.include?(params[:display_chart])
      @display_chart = params[:display_chart]
    end

    return redirect_to(login_path) unless current_user
  end

  def create
    display_chart =
      if params.dig(:user, :project_chart_start_date).present?
        "hours_by_project"
      else
        nil
      end

    respond_to do |format|
      if current_user.update(dashboard_params)
        format.html do
          redirect_to(
            root_path(display_chart:),
            notice: "Successfully updated chart!"
          )
        end
      else
        format.html {redirect_to root_path, alert: "Error updating chart"}
      end
    end
  end

  private

    def dashboard_params
      params.require(:user).permit(:unit_amount, :unit_type, :start_date, :end_date, :project_chart_start_date, :project_chart_end_date)
    end

    def permitted_display_charts
      %w[hours_over_time hours_by_project]
    end
end
