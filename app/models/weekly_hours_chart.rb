class WeeklyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user, unit_amount, start_date, end_date)
    @user         = user
    @unit_amount  = unit_amount
    @start_date   = start_date
    @end_date     = end_date
  end

  def labels
    @labels ||= weeks.map { |sdate| [sdate, sdate.end_of_week] }
    @labels.map do |sdate, edate|
      label = readable_date_range(sdate, edate)
      label = label.sub(/, \d{4}\z/, '')
      label
    end
  end

  def values
    @values ||= weeks.map do |sdate|
      logs = grouped_logs[sdate.strftime("%m %d %Y")]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end
  end

  private

    def logs
      @logs ||= user.logs.active.within(start_date, end_date)
    end

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_week.strftime("%m %d %Y") }
    end

    def weeks
      return @weeks if defined?(@weeks)
      @weeks = []
      @weeks.push start_date

      1.upto(@unit_amount) do |x|
        @weeks.push (start_date.beginning_of_week + x.weeks).to_time
      end

      @weeks
    end

    def readable_date_range(start_at, end_at)
      value = start_at.strftime("%b %-e, %Y")

      return value unless end_at.present?

      if start_at.month != end_at.month
        value = value.gsub /\A\w{3} \d+/ do |match|
          match + " - #{end_at.strftime("%b %-e")}"
        end
      elsif start_at.day != end_at.day
        value = value.gsub /\A\w{3} \d+/ do |match|
          match + " - #{end_at.strftime("%-e")}"
        end
      end

      value
    end
end