class Reports::PayrollReportsController < ApplicationController
  def new
    @payroll_report = Reports::PayrollReport.new
  end

  def create
    @payroll_report = Reports::PayrollReport.new(payroll_report_params)

    respond_to do |format|
      if @payroll_report.valid?
        format.html { render :report }
      else
        format.html { render :new }
      end
    end
  end

  private

    def payroll_report_params
      params.require(:reports_payroll_report).permit(:start_date, :end_date, :user_id)
    end
end
