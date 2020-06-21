class ImportsController < ApplicationController
  require 'csv'

  def new
  end

  def create
    upload_file = params.require(:file).read
    rows = CSV.parse(upload_file)
    @logs = {}

    rows.each_with_index do |row, i|
      log = current_user.logs.build(start_at: row[8], end_at: row[10])
      project = log.project_logs.build(project: Project.find_by(name: row[2]), description: row[13])

      @logs[i] = log
    end

    @result = @logs.values.all?(&:valid?) && @logs.values.all?(&:save)

    render :new
  end
end
