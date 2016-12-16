class HoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user)
    @user       = user
    @end_date   = Time.now.end_of_week
    @start_date = (end_date - 3.weeks).beginning_of_week
  end

  def labels
    @labels ||= weeks.map { |sdate| [sdate, sdate.end_of_week] }
  end

  def values
    @values ||= weeks.map do |sdate|
      logs = grouped_logs[sdate]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end
  end

  def logs
    @logs ||= user.logs.within(start_date, end_date)
  end

  private

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_week.to_time }
    end

    def weeks
      return @weeks if defined?(@weeks)
      @weeks = []
      @weeks.push start_date

      1.upto(3) do |x|
        @weeks.push (start_date + x.weeks).in_time_zone(TIMEZONE).to_time
      end

      @weeks
    end
end