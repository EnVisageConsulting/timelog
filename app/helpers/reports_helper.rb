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

  def report_toggle_link(form_obj, name)
    report_name = form_obj.object.model_name.param_key
    report_params = params[report_name]&.permit! || {}

    value = ToBoolean(report_params[name])
    text = "#{value ? 'Ex' : 'In'}clude " + name.to_s.titleize

    url = url_for({controller: params[:controller], action: params[:action]}.merge(report_name => report_params.merge(name => !value)))

    link_to(text, url) + form_obj.hidden_field(name, value: value)
  end

  class InvalidDateRange < StandardError; end
end
