class Reports::PayrollReportsController < ApplicationController
  def new
    @payroll_report = Reports::PayrollReport.new
  end

  def create
    @payroll_report = Reports::PayrollReport.new(payroll_report_params)

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
  end

  private

    def payroll_report_params
      params.require(:reports_payroll_report).permit(:start_date, :end_date, :user_id)
    end
end
