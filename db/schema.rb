# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160915040226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_projects", force: :cascade do |t|
    t.integer  "client_id",   null: false
    t.integer  "projects_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["client_id"], name: "index_client_projects_on_client_id", using: :btree
    t.index ["projects_id"], name: "index_client_projects_on_projects_id", using: :btree
  end

  create_table "client_users", force: :cascade do |t|
    t.integer  "client_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_users_on_client_id", using: :btree
    t.index ["user_id"], name: "index_client_users_on_user_id", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "start_at",   null: false
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id", using: :btree
  end

  create_table "project_logs", force: :cascade do |t|
    t.integer  "log_id",                                                      null: false
    t.integer  "project_id",                                                  null: false
    t.decimal  "total_allocation",    precision: 3, scale: 2, default: "1.0", null: false
    t.decimal  "billable_allocation", precision: 3, scale: 2, default: "1.0", null: false
    t.text     "description",                                 default: "",    null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["log_id"], name: "index_project_logs_on_log_id", using: :btree
    t.index ["project_id"], name: "index_project_logs_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "archived_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first",                        null: false
    t.string   "last",                         null: false
    t.string   "email",                        null: false
    t.string   "password_digest", default: "", null: false
    t.integer  "role",            default: 0,  null: false
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
