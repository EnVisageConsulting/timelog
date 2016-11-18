class CreateProjectLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :project_logs do |t|
      t.belongs_to :log, null: false
      t.belongs_to :project, null: false
      t.decimal :hours, precision: 4, scale: 2, null: false, default: 0
      t.decimal :total_allocation, precision: 3, scale: 2, null: false, default: 1
      t.decimal :billable_allocation, precision: 3, scale: 2, null: false, default: 1
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
