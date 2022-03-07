class MonthlyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user)
    @user       = user
    @end_date   = Time.now.in_time_zone(TIMEZONE).end_of_month.to_time
    @start_date = (end_date - 29.months).beginning_of_month.to_time
  end

  def labels
    @labels ||= months.map { |sdate| [sdate, sdate.end_of_month] }
  end

  def values
    @values ||= months.map do |sdate|
      logs = grouped_logs[sdate.strftime("%m %d %Y")]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end
  end

  def logs
    @logs ||= user.logs.active.within(start_date, end_date)
  end

  private

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_month.strftime("%m %d %Y") }
    end

    def months
      return @months if defined?(@months)
      @months = []
      @months.push start_date

      1.upto(29) do |x|
        @months.push (start_date + x.months).to_time
      end

      @months
    end
end