class AddNonBillableToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :project_logs, :non_billable, :boolean, null: false, default: false
  end
end
