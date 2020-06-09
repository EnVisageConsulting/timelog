module ReportsHelper
  #invoice_reports
  def more_than_one_project(report)
    report.projects.count > 1
  end

  def personal_report_params(range)
    dates =
    case range
      when "Last Week"
        [1.week.ago.in_time_zone(TIMEZONE).beginning_of_week, 1.week.ago.in_time_zone(TIMEZONE).end_of_week]
      when "This Week"
        [Time.now.in_time_zone(TIMEZONE).beginning_of_week, Time.now.in_time_zone(TIMEZONE).end_of_week]
      when "Last Month"
        [1.month.ago.in_time_zone(TIMEZONE).beginning_of_month, 1.month.ago.in_time_zone(TIMEZONE).end_of_month]
      when "This Month"
        [Time.now.in_time_zone(TIMEZONE).beginning_of_month, Time.now.in_time_zone(TIMEZONE).end_of_month]
      else
        raise InvalidDateRange
    end
    {"start_date"=>dates[0].to_s, "end_date"=>dates[1].to_s, "user_ids"=>[current_user.id.to_s]}
  end

  class InvalidDateRange < StandardError; end
end
