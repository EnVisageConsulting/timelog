module ReportsHelper
  #invoice_reports
  def more_than_one_project(report)
    report.projects.count > 1
  end
end
