class ProjectReportCsvExport < ApplicationCsvExport
  # headers "Date", "Start Time", "Stop Time", "Total Time", "Project", "Description"

  def initialize(report)
    @report = report
  end

  def add_content
    headers = ["Employee", "Date", "Hours", "Description"]

    rows << ["Project Report for: " + @report.projects&.map(&:name)&.to_sentence]
    rows << ["Period of " + @report.start_date + " - " + @report.end_date]
    rows << []

    @report.projects.each do |project|
      total = 0;
      rows << [project.name]
      rows << headers

      @report.grouped_project_logs(project).each do |user, project_logs|
        user_total = project_logs.map(&:hours).inject(:+)
        total += user_total
        project_logs.each do |project_log|
          report_row = []
          report_row << user.name
          report_row << ((@report.start_date.present? && @report.end_date.present?) ? project_log.log.date : "")
          report_row << project_log.hours_two_decimals
          report_row << project_log.description

          rows << report_row
        end
        rows << ["","Subtotal", user_total]
      end
      rows << ["","Total", total]
      rows << []
    end
  end
end