module ReportsHelper
  #invoice_reports
  def more_than_one_project(report)
    report.project.count > 1
  end
end
