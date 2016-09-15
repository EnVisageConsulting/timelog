class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.belongs_to :user, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
