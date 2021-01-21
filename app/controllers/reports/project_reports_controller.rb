class Reports::ProjectReportsController < ApplicationController
  before_action :require_admin
  require 'csv_export/project_report_csv_export'

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

  def csv
    project_report = Reports::ProjectReport.new(start_date: params[:start_date], end_date: params[:end_date],
      projects: Project.find(params[:projects].split("/").map(&:to_i)),
      project_tags: params[:project_tags] && Tag.find(params[:project_tags]&.join("/")&.split("/")&.map(&:to_i))
    )
    csv = ProjectReportCsvExport.new(project_report)
    send_data csv.render, filename: "Project Report - #{Date.today}.csv"
  end

  private

    def project_report_params
      if params[:reports_project_report].nil?
        redirect_to(new_reports_project_report_path, alert: "Incomplete report parameters")
        return {}
      end
      params.require(:reports_project_report).permit(:start_date, :end_date, :sort_date, project_ids: [], project_tag_ids: [])
    end
end
