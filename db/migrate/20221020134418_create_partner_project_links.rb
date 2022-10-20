class CreatePartnerProjectLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :partner_project_links do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.timestamps null: false
      t.foreign_key :users
      t.foreign_key :projects
      t.index [:user_id, :project_id], unique: true
    end
  end
end
