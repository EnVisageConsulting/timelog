class LogImportsController < ApplicationController
  require 'csv'

  def new
  end

  def create
    upload_file = params.require(:file).read
    rows = CSV.parse(upload_file)
    @logs = {}

    rows.each_with_index do |row, i|
      start_date = ActiveSupport::TimeZone.new('America/Chicago').local_to_utc(DateTime.strptime(row[2], "%m/%d/%Y %I:%M:%S %p")).in_time_zone("America/Chicago")
      end_date = ActiveSupport::TimeZone.new('America/Chicago').local_to_utc(DateTime.strptime(row[3], "%m/%d/%Y %I:%M:%S %p")).in_time_zone("America/Chicago")

      log = User.find_by(first: row[0]).logs.build(start_at: start_date, end_at: end_date)
      project = log.project_logs.build(project: Project.find_by(name: row[1]), description: row[4])

      @logs[i] = log
    end

    @result = @logs.values.all?(&:valid?) && @logs.values.all?(&:save)

    render :new
  end
end
