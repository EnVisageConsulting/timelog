module DashboardHelper

  def numerical_hours_chart(unit_amount, unit_type)
    end_date   = Time.now.in_time_zone(TIMEZONE).end_of_day.to_time

    if unit_type == "Days"
      # +7 to include weekends on 30 days, increase if using more
      start_date = (end_date - (unit_amount + 7).days).beginning_of_day.to_time
      @chart ||= DailyHoursChart.new(current_user, unit_amount, start_date, end_date, "Numerical")
    elsif unit_type == "Weeks"
      unit_amount -= 1
      start_date = (end_date - (unit_amount).weeks).beginning_of_week.to_time
      @chart ||= WeeklyHoursChart.new(current_user, unit_amount, start_date, end_date)
    else
      unit_amount -= 1
      start_date = (end_date - (unit_amount).months).beginning_of_month.to_time
      @chart ||= MonthlyHoursChart.new(current_user, unit_amount, start_date, end_date)
    end
  end

  def date_range_hours_chart(start_date, end_date)
    unit_amount = ((end_date - start_date).to_i) / (60 * 60 * 24)

    if unit_amount < 31
      unit_type = "Days"
      @chart ||= DailyHoursChart.new(current_user, unit_amount, start_date, end_date, "Date Range")
    elsif unit_amount < 122
      unit_type = "Weeks"
      unit_amount = ((unit_amount - 1) / 7.to_f).ceil
      @chart ||= WeeklyHoursChart.new(current_user, unit_amount, start_date, end_date)
    elsif unit_amount < 730
      unit_type = "Months"
      unit_amount = (((end_date.year - start_date.year) * 12) + end_date.month) - start_date.month
      @chart ||= MonthlyHoursChart.new(current_user, unit_amount, start_date, end_date)
    else
      unit_type = "Years"
      unit_amount = end_date.year - start_date.year
      @chart ||= YearlyHoursChart.new(current_user, unit_amount, start_date, end_date)
    end
  end

  def chart_total_hours(values)
    hours = values.inject(0, :+) || 0
    strip_insignificant_zeros hours
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

  def is_datetime(date)
    date.methods.include? :strftime
  end
end