# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_01_191200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "logs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.boolean "activated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "non_billable", default: false, null: false
    t.index ["activated"], name: "index_logs_on_activated"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "password_recoveries", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["log_id", "project_id"], name: "index_project_logs_on_log_id_and_project_id", unique: true
    t.index ["log_id"], name: "index_project_logs_on_log_id"
    t.index ["project_id"], name: "index_project_logs_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first", null: false
    t.string "last", null: false
    t.string "email", null: false
    t.string "password_digest", default: "", null: false
    t.integer "role", default: 0, null: false
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
