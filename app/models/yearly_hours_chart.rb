class YearlyHoursChart
  attr_accessor :start_date, :end_date, :user

  def initialize(user, unit_amount, start_date, end_date)
    @user         = user
    @unit_amount  = unit_amount
    @start_date   = start_date
    @end_date     = end_date
  end

  def labels
    @labels ||= years.map { |sdate| [sdate, sdate.end_of_year] }
    @labels.map do |sdate, edate|
      label = sdate.strftime("%Y")
      label
    end
  end

  def values
    @values ||= years.map do |sdate|
      logs = grouped_logs[sdate.strftime("%m %d %Y")]
      logs.present? ? logs.map(&:hours).inject(:+) : 0.0
    end
  end

  private

    def logs
      @logs ||= user.logs.active.within(start_date, end_date)
    end

    def grouped_logs
      @grouped_logs ||= logs.group_by { |log| log.start_at.in_time_zone(TIMEZONE).beginning_of_year.strftime("%m %d %Y") }
    end

    def years
      return @years if defined?(@years)
      @years = []
      @years.push start_date

      1.upto(@unit_amount) do |x|
        @years.push (start_date.beginning_of_year + x.years).to_time
      end

      @years
    end
end