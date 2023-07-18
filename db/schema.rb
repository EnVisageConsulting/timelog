# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_20_141934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "logs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil
    t.boolean "activated", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["activated"], name: "index_logs_on_activated"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "partner_project_links", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "project_id"], name: "index_partner_project_links_on_user_id_and_project_id", unique: true
  end

  create_table "partner_tag_links", force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_partner_tag_links_on_tag_id"
    t.index ["user_id", "tag_id"], name: "index_partner_tag_links_on_user_id_and_tag_id", unique: true
  end

  create_table "password_recoveries", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["token"], name: "index_password_recoveries_on_token", unique: true
    t.index ["user_id"], name: "index_password_recoveries_on_user_id"
  end

  create_table "project_logs", id: :serial, force: :cascade do |t|
    t.integer "log_id", null: false
    t.integer "project_id", null: false
    t.decimal "hours", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "total_allocation", precision: 3, scale: 2, default: "1.0", null: false
    t.decimal "billable_allocation", precision: 3, scale: 2, default: "1.0", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "non_billable", default: false, null: false
    t.index ["log_id", "project_id"], name: "index_project_logs_on_log_id_and_project_id", unique: true
    t.index ["log_id"], name: "index_project_logs_on_log_id"
    t.index ["project_id"], name: "index_project_logs_on_project_id"
  end

  create_table "project_tags", force: :cascade do |t|
    t.bigint "project_log_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_log_id", "tag_id"], name: "index_project_tags_on_project_log_id_and_tag_id", unique: true
    t.index ["project_log_id"], name: "index_project_tags_on_project_log_id"
    t.index ["tag_id"], name: "index_project_tags_on_tag_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first", null: false
    t.string "last", null: false
    t.string "email", null: false
    t.string "password_digest", default: "", null: false
    t.integer "role", default: 0, null: false
    t.datetime "activated_at", precision: nil
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "unit_amount", default: 5
    t.string "unit_type", default: "Days"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  add_foreign_key "partner_project_links", "projects"
  add_foreign_key "partner_project_links", "users"
  add_foreign_key "partner_tag_links", "tags"
  add_foreign_key "partner_tag_links", "users"
end
