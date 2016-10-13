class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string   :name, null: false
      t.datetime :deactivated_at

      t.timestamps null: false
    end
  end
end
