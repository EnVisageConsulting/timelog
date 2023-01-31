class Reports::ProjectReportsController < ApplicationController
  before_action :require_admin_or_partner
  require 'csv_export/project_report_csv_export'

  def new
    @project_report = Reports::ProjectReport.new(project_report_params)
    load_accessible_projects_and_tags
  end

  def create
    @project_report = Reports::ProjectReport.new(project_report_params)
    load_accessible_projects_and_tags

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
    load_accessible_projects_and_tags
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
      project_tags: params[:project_tags] && Tag.find(params[:project_tags]&.join("/")&.split("/")&.map(&:to_i)),
      user_ids: current_user.admin? ? User.active.ids : [current_user.id]
    )
    csv = ProjectReportCsvExport.new(project_report)
    send_data csv.render, filename: "Project Report - #{Date.today}.csv"
  end

  private

    def project_report_params
      return {} if params[:reports_project_report].nil?
      report_params = params.require(:reports_project_report).permit(:start_date, :end_date, :sort_date, :deactivated_projects, :include_partners, project_ids: [], project_tag_ids: [])
      report_params.merge(user_ids: current_user.admin? ? User.active.ids : [current_user.id])
    end

    def load_accessible_projects_and_tags
      @projects =
        if current_user.admin?
          ToBoolean(@project_report.deactivated_projects) ? Project.alphabetized : Project.active
        elsif current_user.partner?
          ToBoolean(@project_report.deactivated_projects) ? current_user.partner_projects.alphabetized : current_user.partner_projects.active
        end

      @tags =
        if current_user.admin?
          Tag.alphabetized
        else
          current_user.partner_tags
        end
    end
end
