class Reports::PersonalReportsController < ApplicationController
  #before_action :require_admin
  require 'csv_export/personal_report_csv_export'

  def new
    @personal_report = Reports::PersonalReport.new(personal_report_params)
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
    personal_report = Reports::PersonalReport.new(start_date: params[:start_date], end_date: params[:end_date], users:  User.alphabetized.find(params[:users].split("/").map(&:to_i)))
    csv = PersonalReportCsvExport.new(personal_report)
    send_data csv.render, filename: "Personal Report - #{Date.today}.csv"
  end

  private

    def personal_report_params
      return {} if params[:reports_personal_report].nil?
      params.require(:reports_personal_report).permit(:start_date, :end_date, :sort_date, :deactivated_users, :partner_users, user_ids: [])
    end

    def load_accessible_users
      @users =
        if current_user.admin?
          list = ToBoolean(@personal_report.deactivated_users) ? User.alphabetized : User.undeactivated
          list = list.where.not(role: :partner) unless ToBoolean(@personal_report.partner_users)
          list
        else
          [current_user]
        end
    end
end
