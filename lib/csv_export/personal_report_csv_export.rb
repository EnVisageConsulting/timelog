class PersonalReportCsvExport < ApplicationCsvExport
  # headers "Date", "Start Time", "Stop Time", "Total Time", "Project", "Description"

  def initialize(report)
    @report = report
  end

  def add_content
    headers = ["Date", "Start Time", "Stop Time", "Total Time", "Project", "Description"]

    rows << ["Personal Report for: " + @report.users&.map(&:name)&.to_sentence]
    rows << ["Period of " + @report.start_date + " - " + @report.end_date]
    rows << []

    @report.users.each do |u|
      total = 0;
      rows << [u.name]
      rows << headers

      @report.grouped_logs(u).each do |date, logs|
        date_total = 0;
        logs.each_with_index do |log, index|
          log.project_logs.each do |project_log|
            report_row = []
            total      += project_log.hours
            date_total += project_log.hours

            report_row << log.date
            report_row << log.start_time
            report_row << log.end_time
            report_row << project_log.hours_two_decimals
            report_row << project_log.project.name
            # report_row << project_log.project_tags.map(&:tag).pluck(:name).to_sentence
            report_row << project_log.description

            rows << report_row
          end
        end
        rows << ["","","Subtotal", date_total]
        rows << []
      end
      rows << ["","","Total", total]
      rows << []
    end
  end
end