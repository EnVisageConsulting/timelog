class AddDashboardChartFieldsForUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :unit_amount, :integer, default: 5
    add_column :users, :unit_type, :string, default: "Days"
    add_column :users, :start_date, :datetime, default: nil
    add_column :users, :end_date, :datetime, default: nil
  end
end
