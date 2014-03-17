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

ActiveRecord::Schema.define(version: 20140127065208) do

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

  add_index "alumni", ["user_id"], name: "index_alumni_on_user_id", using: :btree

  create_table "announcements", force: true do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "announcements", ["user_id"], name: "index_announcements_on_user_id", using: :btree

  create_table "candidate_quizzes", force: true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "candidate_quizzes", ["user_id"], name: "index_candidate_quizzes_on_user_id", using: :btree

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

  create_table "companies", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "company_id"
    t.text     "comments"
    t.string   "cellphone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id", using: :btree

  create_table "course_offerings", force: true do |t|
    t.integer  "course_id"
    t.integer  "course_semester_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "section"
    t.string   "time"
    t.string   "location"
    t.integer  "num_students"
    t.text     "notes"
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
    t.string   "staff_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_staff_members", ["course_offering_id", "staff_member_id"], name: "index_course_staff_on_course_offering_and_staff_member_ids", using: :btree

  create_table "course_surveys", force: true do |t|
    t.integer  "course_offering_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "survey_time"
    t.string   "status"
    t.integer  "max_surveyors"
  end

  add_index "course_surveys", ["course_offering_id"], name: "index_course_surveys_on_course_offering_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "department"
    t.string   "course_name"
    t.integer  "units"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exams_count",  default: 0
    t.text     "course_guide"
    t.string   "name"
  end

  create_table "dept_tours", force: true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "email"
    t.string   "phone"
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
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "event_type"
    t.boolean  "need_transportation"
    t.string   "view_permission_roles"
    t.string   "rsvp_permission_roles"
    t.integer  "max_rsvps"
  end

  create_table "exams", force: true do |t|
    t.integer  "course_offering_id"
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

  add_index "exams", ["course_offering_id"], name: "index_exams_on_course_offering_id", using: :btree

  create_table "indrel_event_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indrel_events", force: true do |t|
    t.datetime "time"
    t.integer  "location_id"
    t.integer  "indrel_event_type_id"
    t.text     "food"
    t.text     "prizes"
    t.integer  "turnout"
    t.integer  "company_id"
    t.integer  "contact_id"
    t.string   "officer"
    t.text     "feedback"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "indrel_events", ["company_id"], name: "index_indrel_events_on_company_id", using: :btree
  add_index "indrel_events", ["contact_id"], name: "index_indrel_events_on_contact_id", using: :btree
  add_index "indrel_events", ["indrel_event_type_id"], name: "index_indrel_events_on_indrel_event_type_id", using: :btree
  add_index "indrel_events", ["location_id"], name: "index_indrel_events_on_location_id", using: :btree

  create_table "infosession_requests", force: true do |t|
    t.string   "company_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "name"
    t.string   "title"
    t.string   "phone"
    t.string   "email"
    t.string   "alt_name"
    t.string   "alt_title"
    t.string   "alt_phone"
    t.string   "alt_email"
    t.text     "pref_date"
    t.text     "pref_food"
    t.text     "pref_ad"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_semesters", force: true do |t|
    t.integer  "year"
    t.string   "season"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "coursesurveys_active"
  end

  create_table "member_semesters_users", force: true do |t|
    t.integer "member_semester_id"
    t.integer "user_id"
  end

  add_index "member_semesters_users", ["member_semester_id"], name: "index_member_semesters_users_on_member_semester_id", using: :btree
  add_index "member_semesters_users", ["user_id"], name: "index_member_semesters_users_on_user_id", using: :btree

  create_table "mobile_carriers", force: true do |t|
    t.string   "name"
    t.string   "sms_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "quiz_questions", force: true do |t|
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_responses", force: true do |t|
    t.integer  "quiz_question_id"
    t.integer  "candidate_quiz_id"
    t.string   "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quiz_responses", ["candidate_quiz_id"], name: "index_quiz_responses_on_candidate_quiz_id", using: :btree
  add_index "quiz_responses", ["quiz_question_id"], name: "index_quiz_responses_on_quiz_question_id", using: :btree

  create_table "resume_book_urls", force: true do |t|
    t.integer  "resume_book_id"
    t.datetime "expiration_date"
    t.text     "feedback"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "download_count"
    t.string   "company"
    t.string   "name"
    t.string   "email"
    t.string   "transaction_id"
  end

  add_index "resume_book_urls", ["resume_book_id"], name: "index_resume_book_urls_on_resume_book_id", using: :btree

  create_table "resume_books", force: true do |t|
    t.string   "title"
    t.string   "remarks"
    t.text     "details"
    t.date     "cutoff_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "iso_file_name"
    t.string   "iso_content_type"
    t.integer  "iso_file_size"
    t.datetime "iso_updated_at"
  end

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
    t.string   "confirmed"
    t.integer  "confirmed_by"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.integer  "transportation_ability"
  end

  add_index "rsvps", ["event_id"], name: "index_rsvps_on_event_id", using: :btree
  add_index "rsvps", ["user_id", "event_id"], name: "index_rsvps_on_user_id_and_event_id", using: :btree
  add_index "rsvps", ["user_id"], name: "index_rsvps_on_user_id", using: :btree

  create_table "slideshows", force: true do |t|
    t.integer  "member_semester_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slideshow_file_name"
    t.string   "slideshow_content_type"
    t.integer  "slideshow_file_size"
    t.datetime "slideshow_updated_at"
  end

  create_table "staff_members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "release_surveys"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.string   "title"
    t.text     "interests"
    t.string   "home_page"
    t.string   "office"
    t.string   "phone_number"
    t.string   "email"
  end

  create_table "survey_question_responses", force: true do |t|
    t.integer  "survey_question_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_responses"
    t.integer  "course_staff_member_id"
  end

  add_index "survey_question_responses", ["survey_question_id"], name: "index_survey_question_responses_on_survey_question_id", using: :btree

  create_table "survey_questions", force: true do |t|
    t.string   "question_text"
    t.string   "keyword"
    t.float    "mean_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max"
  end

  create_table "surveyors_candidates", id: false, force: true do |t|
    t.integer "course_survey_id"
    t.integer "user_id"
  end

  add_index "surveyors_candidates", ["course_survey_id", "user_id"], name: "index_surveyors_candidates_on_course_survey_id_and_user_id", using: :btree

  create_table "tutor_slot_preferences", force: true do |t|
    t.integer  "tutor_slot_id"
    t.integer  "user_id"
    t.integer  "preference"
    t.integer  "room_preference"
    t.boolean  "recieved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tutor_slot_preferences", ["tutor_slot_id"], name: "index_tutor_slot_preferences_on_tutor_slot_id", using: :btree
  add_index "tutor_slot_preferences", ["user_id"], name: "index_tutor_slot_preferences_on_user_id", using: :btree

  create_table "tutor_slots", force: true do |t|
    t.string   "room"
    t.string   "day"
    t.time     "start_time"
    t.integer  "duration_in_minutes"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                               null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "approved",               default: false, null: false
    t.boolean  "private"
    t.date     "date_of_birth"
    t.string   "phone_number"
    t.boolean  "sms_alerts"
    t.integer  "candidate_quiz_id"
    t.integer  "mobile_carrier_id"
    t.boolean  "should_reset_session"
    t.string   "local_address"
    t.string   "perm_address"
    t.string   "committee_preferences"
    t.text     "suggestion"
    t.string   "graduation_semester"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["candidate_quiz_id"], name: "index_users_on_candidate_quiz_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["mobile_carrier_id"], name: "index_users_on_mobile_carrier_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "yearbooks", force: true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

end
