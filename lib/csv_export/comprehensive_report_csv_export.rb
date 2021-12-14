class ComprehensiveReportCsvExport < ApplicationCsvExport
  # headers "Date", "Start Time", "Stop Time", "Total Time", "Project", "Description"

  def initialize(report)
    @report = report
  end

  def add_content
    headers = ["Date", "Start Time", "Stop Time", "Total Time", "Project", "Project Tags", "Description"]

    rows << ["Comprehensive Report for: " + (@report.users.length == User.undeactivated.length ? "All Team Members" : @report.users&.map(&:name)&.to_sentence)]
    rows << ["Period of " + @report.start_date + " - " + @report.end_date]
    rows << []

    @report.users.each do |u|
      rows << [u.name]
      @report.projects.each do |p|
        total = 0;
        rows << [p.name]
        rows << headers

        @report.grouped_project_logs(p,u).each do |date, project_logs|
          date_total = 0
          project_logs.each_with_index do |project_log, index|
            log = project_log.log
            report_row = []
            total      += project_log.hours
            date_total += project_log.hours

            report_row << log.date
            report_row << log.start_time
            report_row << log.end_time
            report_row << project_log.hours_two_decimals
            report_row << project_log.project.name
            report_row << project_log.project_tags.map(&:tag).pluck(:name).to_sentence
            report_row << project_log.description
            rows << report_row
          end

          rows << ["","","Subtotal", date_total]
        end
        rows << ["","","Total", total]
      end
      rows << []
    end
  end
end