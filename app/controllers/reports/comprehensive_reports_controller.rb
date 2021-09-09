class Reports::ComprehensiveReportsController < ApplicationController
  before_action :require_admin
  require 'csv_export/comprehensive_report_csv_export'

  def new
    @comprehensive_report = Reports::ComprehensiveReport.new
  end

  def create
    @comprehensive_report = Reports::ComprehensiveReport.new(comprehensive_report_params)

    respond_to do |format|
      if @comprehensive_report.valid?
        format.html { redirect_to reports_comprehensive_reports_path(reports_comprehensive_report: comprehensive_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @comprehensive_report = Reports::ComprehensiveReport.new(comprehensive_report_params)
    @date =
    if @comprehensive_report.start_at.present? && @comprehensive_report.end_at.present?
      "Period of: #{@comprehensive_report.start_date} - #{@comprehensive_report.end_date}"
    elsif @comprehensive_report.start_at.present?
      "Period of: #{@comprehensive_report.start_date} - Now"
    elsif @comprehensive_report.end_at.present?
      "Period Before #{@comprehensive_report.end_date}"
    else
      "All Logs"
    end
  end

  def csv
    comprehensive_report = Reports::ComprehensiveReport.new(start_date: params[:start_date], end_date: params[:end_date],
      projects: Project.find(params[:projects].split("/").map(&:to_i)), users: User.find(params[:users].split("/").map(&:to_i))
    )
    csv = ComprehensiveReportCsvExport.new(comprehensive_report)
    send_data csv.render, filename: "Comprehensive Report - #{Date.today}.csv"
  end

  def csv_matrix
    matrix_report = Reports::ComprehensiveReport.new(start_date: params[:start_date], end_date: params[:end_date],
      projects: Project.find(params[:projects].split("/").map(&:to_i)), users: User.find(params[:users].split("/").map(&:to_i))
    )
    csv = MatrixReportCsvExport.new(matrix_report)
    send_data csv.render, filename: "Matrix Report - #{Date.today}.csv"
  end

  private

    def comprehensive_report_params
      if params[:reports_comprehensive_report].nil?
        redirect_to(new_reports_comprehensive_report_path, alert: "Incomplete report parameters")
        return {}
      end
      params.require(:reports_comprehensive_report).permit(:start_date, :end_date, project_ids: [], user_ids: [])
    end
end
