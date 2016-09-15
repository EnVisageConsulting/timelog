class CreateClientUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :client_users do |t|
      t.belongs_to :client, null: false
      t.belongs_to :user, null: false
      t.timestamps null: false
    end
  end
end
