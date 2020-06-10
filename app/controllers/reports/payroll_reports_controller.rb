class Reports::PayrollReportsController < ApplicationController
  #before_action :require_admin

  def new
    @payroll_report = Reports::PayrollReport.new
    @users = accessible_users
  end

  def create
    @payroll_report = Reports::PayrollReport.new(payroll_report_params)
    @users = accessible_users

    respond_to do |format|
      if @payroll_report.valid?
        format.html { redirect_to reports_payroll_reports_path(reports_payroll_report: payroll_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @payroll_report = Reports::PayrollReport.new(payroll_report_params)
    @users = accessible_users
  end

  private

    def payroll_report_params
      return redirect_to(new_reports_payroll_report_path, alert: "Incomplete report parameters") if params[:reports_payroll_report].nil?
      params.require(:reports_payroll_report).permit(:start_date, :end_date, :sort_date, user_ids: [])
    end

    def accessible_users
      current_user.admin? ? User.undeactivated : [current_user]
    end
end
