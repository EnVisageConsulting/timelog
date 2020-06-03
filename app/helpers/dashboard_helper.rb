module DashboardHelper
  def hours_chart
    @hours_chart ||= HoursChart.new(current_user)
  end

  def hours_chart_labels
    hours_chart.labels.map do |sdate, edate|
      label = readable_date_range(sdate, edate)
      label = label.sub(/, \d{4}\z/, '')
      label
    end.join("|")
  end

  def hours_chart_values
    hours_chart.values.join("|")
  end

  def current_week_hours
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_week
    edate = sdate.end_of_week
    hours = current_user.logs.active.within(sdate, edate).map(&:hours).inject(:+) || 0

    strip_insignificant_zeros hours
  end

  def current_day_hours
    sdate = Time.now.in_time_zone(TIMEZONE).beginning_of_day
    edate = sdate.end_of_day
    hours = current_user.logs.active.within(sdate, edate).map(&:hours).inject(:+) || 0

    strip_insignificant_zeros hours
  end

  def recent_logs
    @recent_logs ||= current_user.logs.active.latest.limit(Kaminari.config.default_per_page)
  end
end