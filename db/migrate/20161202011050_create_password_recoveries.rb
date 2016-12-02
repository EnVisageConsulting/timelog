class CreatePasswordRecoveries < ActiveRecord::Migration[5.0]
  def change
    create_table :password_recoveries do |t|
      t.belongs_to :user,     null: false
      t.string :token,        null: false
      t.datetime :expired_at, null: false
      t.timestamps            null: false
    end

    add_index :password_recoveries, :token, unique: true
  end
end
