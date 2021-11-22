class MatrixReportCsvExport < ApplicationCsvExport

  def initialize(report)
    @report = report
  end

  def add_content
    rows << ["Matrix Report from #{@report.start_date}-#{@report.end_date}"]

    projects = [""]
    project_totals = {}

    @report.projects.each do |project|
      projects << project.name
      project_totals[project.id] = 0
    end
    projects << "Team Member Total"
    rows << projects

    @report.users.each do |user|
      user_row = [user.name]
      user_total = 0
      @report.projects.each do |project|
        amount = @report.project_user_total_hours(project, user)
        user_total += amount
        project_totals[project.id] += amount
        user_row << amount
      end
      user_row << user_total
      rows << user_row
    end

    grand_total = 0
    project_total_row = ["Project Total"]
    project_totals.each do |id, total|
      project_total_row << total
      grand_total += total
    end
    project_total_row << grand_total
    rows << project_total_row
  end
end