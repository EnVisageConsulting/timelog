class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.belongs_to :user, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.boolean :activated, null: false, default: false

      t.timestamps null: false
    end

    add_index :logs, :activated
  end
end
