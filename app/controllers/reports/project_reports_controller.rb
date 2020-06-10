class Reports::ProjectReportsController < ApplicationController
  before_action :require_admin

  def new
    @project_report = Reports::ProjectReport.new
  end

  def create
    @project_report = Reports::ProjectReport.new(project_report_params)

    respond_to do |format|
      if @project_report.valid?
        format.html { redirect_to reports_project_reports_path(reports_project_report: project_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @project_report = Reports::ProjectReport.new(project_report_params)
    @date =
    if @project_report.start_at.present? && @project_report.end_at.present?
      "Period of: #{@project_report.start_date} - #{@project_report.end_date}"
    elsif @project_report.start_at.present?
      "Period of: #{@project_report.start_date} - Now"
    elsif @project_report.end_at.present?
      "Period Before #{@project_report.end_date}"
    else
      "All Logs"
    end
  end

  private

    def project_report_params
      if params[:reports_project_report].nil?
        redirect_to(new_reports_project_report_path, alert: "Incomplete report parameters")
        return {}
      end
      params.require(:reports_project_report).permit(:start_date, :end_date, project_ids: [])
    end
end
