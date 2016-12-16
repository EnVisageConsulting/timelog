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
end