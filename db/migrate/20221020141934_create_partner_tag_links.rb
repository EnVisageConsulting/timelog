class CreatePartnerTagLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :partner_tag_links do |t|
      t.integer :user_id, null: false
      t.belongs_to :tag, null: false, foreign_key: true
      t.timestamps null: false
      t.foreign_key :users
      t.index [:user_id, :tag_id], unique: true
    end
  end
end
