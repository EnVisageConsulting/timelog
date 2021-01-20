class CreateProjectTags < ActiveRecord::Migration[6.0]
  def change
    create_table :project_tags do |t|
      t.belongs_to :project_log, null: false
      t.belongs_to :tag, null: false

      t.timestamps
    end

    add_index :project_tags, [:project_log_id, :tag_id], unique: true
  end
end
