class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first, null: false
      t.string :last, null: false
      t.string :email, null: false
      t.string :password_digest, null: false, default: ''
      t.integer :role, default: 0, null: false
      t.datetime :activated_at
      t.datetime :deactivated_at

      t.timestamps null: false
    end
  end
end
