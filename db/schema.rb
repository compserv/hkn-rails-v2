# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131225055538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: true do |t|
    t.integer  "requester_id"
    t.integer  "candidate_id"
    t.boolean  "confirmed"
    t.boolean  "rejected"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "rsvp_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "exams", force: true do |t|
    t.integer  "course_id"
    t.string   "exam_type"
    t.integer  "number"
    t.boolean  "is_solution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "year"
    t.string   "semester"
  end

  create_table "member_semesters", force: true do |t|
    t.integer  "year"
    t.string   "season"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_semesters_users", force: true do |t|
    t.integer "member_semester_id"
    t.integer "user_id"
  end

  add_index "member_semesters_users", ["member_semester_id"], name: "index_member_semesters_users_on_member_semester_id", using: :btree
  add_index "member_semesters_users", ["user_id"], name: "index_member_semesters_users_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "rsvps", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "confirmed"
    t.integer  "confirmed_by"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
  end

  add_index "rsvps", ["user_id", "event_id"], name: "index_rsvps_on_user_id_and_event_id", using: :btree

  create_table "semester_roles", force: true do |t|
    t.integer  "member_semester_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "semester_roles", ["member_semester_id"], name: "index_semester_roles_on_member_semester_id", using: :btree
  add_index "semester_roles", ["role_id"], name: "index_semester_roles_on_role_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
