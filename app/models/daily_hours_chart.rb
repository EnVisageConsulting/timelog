class DailyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user)
    @user       = user
    @end_date   = Time.now.in_time_zone(TIMEZONE).end_of_day.to_time
    @start_date = (end_date - 29.days).beginning_of_day.to_time
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

  def logs
    @logs ||= user.logs.active.within(start_date, end_date)
  end

  private

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_day.to_time }
    end

    def days
      return @days if defined?(@days)
      @days = []
      num_days = 0
      num_work_days = 0

      until num_work_days == 30
        if (weekday?(end_date - num_days.days) || has_logs?(end_date - num_days.days))
          @days.push (end_date - num_days.days).in_time_zone(TIMEZONE).beginning_of_day.to_time
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