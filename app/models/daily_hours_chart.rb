class DailyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user, unit_amount, start_date, end_date, filter_type)
    @user         = user
    @unit_amount  = unit_amount
    @start_date   = start_date
    @end_date     = end_date
    @filter_type  = filter_type
  end

  def labels
    @labels ||= days.map { |sdate| sdate.strftime("%a") }
  end

  def values
    @values ||= days.map do |sdate|
      logs = grouped_logs[sdate]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end.reverse
  end

  private

    def logs
      @logs ||= user.logs.active.within(start_date, end_date)
    end

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_day.to_time }
    end

    def days
      return @days if defined?(@days)
      @days = []
      num_days = 0
      num_work_days = 0

      until (@filter_type == "Numerical") ? (num_work_days == @unit_amount) : (num_days > @unit_amount)
        day = end_date - num_days.days
        if (weekday?(day) || has_logs?(day))
          @days.push (day).in_time_zone(TIMEZONE).beginning_of_day.to_time
          num_work_days += 1
        end
        num_days += 1
      end

      @days.reverse
    end

    def weekday?(date)
      (1..5).include?(date.wday)
    end

    def has_logs?(date)
      user.logs.active.within(date.in_time_zone(TIMEZONE).beginning_of_day, date.in_time_zone(TIMEZONE).end_of_day).size > 0
    end
end