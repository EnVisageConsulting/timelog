class Reports::PersonalReportsController < ApplicationController
  #before_action :require_admin
  require 'csv_export/personal_report_csv_export'

  def new
    @personal_report = Reports::PersonalReport.new
    load_accessible_users
  end

  def create
    @personal_report = Reports::PersonalReport.new(personal_report_params)
    load_accessible_users

    respond_to do |format|
      if @personal_report.valid?
        format.html { redirect_to reports_personal_reports_path(reports_personal_report: personal_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @personal_report = Reports::PersonalReport.new(personal_report_params)
    load_accessible_users
  end

  def csv
    personal_report = Reports::PersonalReport.new(start_date: params[:start_date], end_date: params[:end_date], users:  User.find(params[:users].split("/").map(&:to_i)))
    csv = PersonalReportCsvExport.new(personal_report)
    send_data csv.render, filename: "Personal Report - #{Date.today}.csv"
  end

  private

    def personal_report_params
      return redirect_to(new_reports_personal_report_path) if params[:reports_personal_report].nil?
      params.require(:reports_personal_report).permit(:start_date, :end_date, :sort_date, :deactivated_users, user_ids: [])
    end

    def load_accessible_users
      @include_deactivated_users = params[:reports_personal_report]&.dig(:deactivated_users) == "true" || false
      @users = current_user.admin? ? (@include_deactivated_users ? User.alphabetized : User.undeactivated) : [current_user]
    end
end
