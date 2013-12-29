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

ActiveRecord::Schema.define(version: 20131229030124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alumni", force: true do |t|
    t.string   "grad_semester"
    t.string   "grad_school"
    t.string   "job_title"
    t.string   "company"
    t.integer  "salary"
    t.integer  "user_id"
    t.string   "perm_email"
    t.string   "location"
    t.text     "suggestions"
    t.boolean  "mailing_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "course_offerings", force: true do |t|
    t.integer  "course_id"
    t.integer  "course_semester_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_offerings", ["course_id", "course_semester_id"], name: "index_course_offerings_on_course_id_and_course_semester_id", using: :btree

  create_table "course_semesters", force: true do |t|
    t.string   "season"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_staff_members", force: true do |t|
    t.integer  "course_offering_id"
    t.integer  "staff_member_id"
    t.integer  "course_semester_id"
    t.integer  "course_id"
    t.string   "staff_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_staff_members", ["course_id"], name: "index_course_staff_members_on_course_id", using: :btree
  add_index "course_staff_members", ["course_offering_id", "staff_member_id"], name: "index_course_staff_on_course_offering_and_staff_member_ids", using: :btree
  add_index "course_staff_members", ["course_semester_id"], name: "index_course_staff_members_on_course_semester_id", using: :btree

  create_table "course_surveys", force: true do |t|
    t.integer  "staff_member_id"
    t.integer  "course_staff_member_id"
    t.integer  "course_offering_id"
    t.integer  "course_id"
    t.integer  "course_semester_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "survey_time"
    t.string   "status"
    t.integer  "max_surveyors"
    t.integer  "number_responses"
  end

  add_index "course_surveys", ["course_id"], name: "index_course_surveys_on_course_id", using: :btree
  add_index "course_surveys", ["course_offering_id"], name: "index_course_surveys_on_course_offering_id", using: :btree
  add_index "course_surveys", ["course_staff_member_id"], name: "index_course_surveys_on_course_staff_member_id", using: :btree
  add_index "course_surveys", ["staff_member_id", "course_id"], name: "index_course_surveys_on_staff_member_id_and_course_id", using: :btree
  add_index "course_surveys", ["staff_member_id", "course_semester_id"], name: "index_course_surveys_on_staff_member_id_and_course_semester_id", using: :btree
  add_index "course_surveys", ["staff_member_id"], name: "index_course_surveys_on_staff_member_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "department"
    t.string   "course_name"
    t.integer  "units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dept_tours", force: true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "email"
    t.string   "phone"
    t.datetime "submitted"
    t.text     "comments"
    t.boolean  "responded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elections", force: true do |t|
    t.integer  "member_semester_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "elections", ["member_semester_id"], name: "index_elections_on_member_semester_id", using: :btree

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

  add_index "exams", ["course_id"], name: "index_exams_on_course_id", using: :btree

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

  create_table "position_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "position_id"
    t.boolean  "nominated"
    t.boolean  "elected"
    t.integer  "sid"
    t.integer  "keycard"
    t.boolean  "midnight_meeting"
    t.boolean  "txt"
    t.datetime "elected_time"
    t.string   "non_hkn_email"
    t.string   "desired_username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_users", ["position_id"], name: "index_position_users_on_position_id", using: :btree
  add_index "position_users", ["user_id"], name: "index_position_users_on_user_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "election_id"
    t.integer  "number_of_position"
  end

  add_index "positions", ["election_id"], name: "index_positions_on_election_id", using: :btree

  create_table "resumes", force: true do |t|
    t.decimal  "overall_gpa"
    t.decimal  "major_gpa"
    t.text     "resume_text"
    t.integer  "graduation_year"
    t.string   "graduation_semester"
    t.integer  "user_id"
    t.boolean  "included"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "resumes", ["user_id"], name: "index_resumes_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role_type"
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

  create_table "staff_members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "release_surveys"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_question_responses", force: true do |t|
    t.integer  "survey_question_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_question_responses", ["survey_question_id"], name: "index_survey_question_responses_on_survey_question_id", using: :btree

  create_table "survey_questions", force: true do |t|
    t.integer  "course_survey_id"
    t.string   "question_text"
    t.string   "keyword"
    t.float    "mean_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_questions", ["course_survey_id"], name: "index_survey_questions_on_course_survey_id", using: :btree

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
