class AddProjectChartMonthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :project_chart_start_date, :datetime
    add_column :users, :project_chart_end_date, :datetime
  end
end
