class MonthlyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user, unit_amount, start_date, end_date)
    @user         = user
    @unit_amount  = unit_amount
    @start_date   = start_date
    @end_date     = end_date
  end

  def labels
    @labels ||= months.map { |sdate| [sdate, sdate.end_of_month] }
    @labels.map do |sdate, edate|
      label = sdate.strftime("%B")
      label
    end
  end

  def values
    first_month = months.first
    @values ||= months.map do |sdate|
      logs = grouped_logs[sdate.strftime("%m %d %Y")]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end
  end

  private

    def logs
      @logs ||= user.logs.active.within(@start_date, @end_date)
    end

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_month.strftime("%m %d %Y") }
    end

    def months
      return @months if defined?(@months)
      @months = []
      @months.push @start_date.beginning_of_month

      1.upto(@unit_amount) do |x|
        @months.push (@start_date.beginning_of_month + x.months).to_time
      end

      @months
    end
end