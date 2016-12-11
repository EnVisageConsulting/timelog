class RemoveClients < ActiveRecord::Migration[5.0]
  def change
    drop_table :clients
    drop_table :client_projects
    drop_table :client_users
  end
end
