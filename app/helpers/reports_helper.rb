module ReportsHelper
  def more_than_one_project(report)
    report.projects.count > 1
  end

  def personal_report_params(range)
    dates = personal_report_date_range(range)
    {"start_date"=>dates[0].to_s, "end_date"=>dates[1].to_s, "user_ids"=>[current_user.id.to_s]}
  end

  def personal_report_date_range(range)
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
    dates.map{ |d| d.strftime("%m/%d/%Y")}
  end

  def deactivated_report_params(report, obj, include_deactivated)
    report = report.class.to_s.gsub("Reports::", "reports_").underscore
    if params[report.to_sym]&.dig(obj.to_sym).present?
      query_string = request.query_string.gsub("#{obj}%5D=#{include_deactivated}", "#{obj}%5D=#{!include_deactivated}")
      "?#{query_string}"
    else
      "?#{request.query_string}&#{report}%5B#{obj}%5D=#{!include_deactivated}"
    end
  end

  class InvalidDateRange < StandardError; end
end
