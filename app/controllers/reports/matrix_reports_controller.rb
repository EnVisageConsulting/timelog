class Reports::MatrixReportsController < ApplicationController
  before_action :require_admin
  require 'csv_export/matrix_report_csv_export'

  def new
    @matrix_report = Reports::MatrixReport.new
  end

  def create
    @matrix_report = Reports::MatrixReport.new(matrix_report_params)

    respond_to do |format|
      if @matrix_report.valid?
        format.html { redirect_to reports_matrix_reports_path(reports_matrix_report: matrix_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @matrix_report = Reports::MatrixReport.new(matrix_report_params)
    @date =
    if @matrix_report.start_at.present? && @matrix_report.end_at.present?
      "Period of: #{@matrix_report.start_date} - #{@matrix_report.end_date}"
    elsif @matrix_report.start_at.present?
      "Period of: #{@matrix_report.start_date} - Now"
    elsif @matrix_report.end_at.present?
      "Period Before #{@matrix_report.end_date}"
    else
      "All Logs"
    end
  end

  def csv
    matrix_report = Reports::MatrixReport.new(start_date: params[:start_date], end_date: params[:end_date],
      projects: Project.find(params[:projects].split("/").map(&:to_i)), users: User.find(params[:users].split("/").map(&:to_i))
    )
    csv = MatrixReportCsvExport.new(matrix_report)
    send_data csv.render, filename: "Matrix Report - #{Date.today}.csv"
  end

  private

    def matrix_report_params
      if params[:reports_matrix_report].nil?
        redirect_to(new_reports_matrix_report_path, alert: "Incomplete report parameters")
        return {}
      end
      params.require(:reports_matrix_report).permit(:start_date, :end_date, project_ids: [], user_ids: [])
    end
end
