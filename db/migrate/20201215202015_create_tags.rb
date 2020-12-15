class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string   :name, null: false
      t.datetime :deactivated_at

      t.timestamps null: false
    end
  end
end
