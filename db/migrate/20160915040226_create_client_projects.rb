class CreateClientProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :client_projects do |t|
      t.belongs_to :client, null: false
      t.belongs_to :projects, null: false
      t.timestamps null: false
    end
  end
end
