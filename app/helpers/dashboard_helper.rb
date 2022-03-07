module DashboardHelper
  def daily_hours_chart
    @daily_hours_chart ||= DailyHoursChart.new(current_user)
  end

  def daily_hours_chart_labels
    daily_hours_chart.labels.join("|")
  end

  def daily_hours_chart_values
    daily_hours_chart.values.join("|")
  end

  def weekly_hours_chart
    @weekly_hours_chart ||= WeeklyHoursChart.new(current_user)
  end

  def weekly_hours_chart_labels
    weekly_hours_chart.labels.map do |sdate, edate|
      label = readable_date_range(sdate, edate)
      label = label.sub(/, \d{4}\z/, '')
      label
    end.join("|")
  end

  def weekly_hours_chart_values
    weekly_hours_chart.values.join("|")
  end

  def monthly_hours_chart
    @monthly_hours_chart ||= MonthlyHoursChart.new(current_user)
  end

  def monthly_hours_chart_labels
    monthly_hours_chart.labels.map do |sdate, edate|
      label = sdate.strftime("%B")
      label
    end.join("|")
  end

  def monthly_hours_chart_values
    monthly_hours_chart.values.join("|")
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

  def hours_completed_class
    current_day_hours == "0" ? "dashboard-hours-completed-zero" : "dashboard-hours-completed"
  end

  def recent_logs
    @recent_logs = current_user.logs.latest.includes(project_logs: :project).limit(Kaminari.config.default_per_page)
  end

  # def logs_last_week
  #   current_user.logs.within(1.week.ago.in_time_zone(TIMEZONE).beginning_of_week, 1.week.ago.in_time_zone(TIMEZONE).end_of_week).active.latest
  # end

  # def logs_this_week
  #   current_user.logs.within(Time.now.in_time_zone(TIMEZONE).beginning_of_week, Time.now.in_time_zone(TIMEZONE).end_of_week).active.latest
  # end

  # def logs_last_month
  #   current_user.logs.within(1.month.ago.in_time_zone(TIMEZONE).beginning_of_month, 1.month.ago.in_time_zone(TIMEZONE).end_of_month).active.latest
  # end

  # def logs_this_month
  #   current_user.logs.within(Time.now.in_time_zone(TIMEZONE).beginning_of_month, Time.now.in_time_zone(TIMEZONE).end_of_month).active.latest
  # end
end