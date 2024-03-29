HknRails::Application.routes.draw do

  match "courseguides", to: "courseguides#index", via: :get, as: "courseguides"
  match "courseguides/:dept/:name", to: "courseguides#show", via: :get, as: "courseguide_show"
  match "courseguides/edit/:dept/:name", to: "courseguides#edit", via: :get, as: "courseguide_edit"
  match "courseguides/edit/:dept/:name", to: "courseguides#update", via: :post, as: "courseguides_update"

  root to: "pages#home"

  devise_for :users, controllers: { registrations: "registrations" }

  match 'notifications/read', to: 'notifications#index', via: :get, as: "notifications"

  match "dept_tours/success", to: "dept_tours#success", via: :get, as: "dept_tours_success"
  match "dept_tours/:id", to: "dept_tours#respond_to_tour", via: :post
  match "exams/search(/:q)", to: "exams#search", via: :get, :as => :exams_search
  match "exams/course/:dept_abbr/:full_course_number", to: "exams#course", via: :get, :as => :exams_course
  match "users/approve/:id", to: "users#approve", via: :post, as: "users_approve"
  match "users/list(/:category)", to: "users#list", via: :get, as: "users_list"
  match "users/roles/:id", to: "users#roles", via: :get, as: "edit_roles_user"
  match "users/roles/:id", to: "users#alter_roles", via: :post, as: "alter_roles_user"
  match "resumes/upload_for/:user_id" => "resumes#upload_for", via: :get, :as => :resumes_upload_for
  match "resumes/:id/download" => "resumes#download", via: :get, :as => :resume_download
  match "resumes/status_list" => "resumes#status_list", via: :get, :as => :resumes_status_list
  match "resume_books/:id/download_pdf" => "resume_books#download_pdf", via: :get, :as => :resume_book_download_pdf
  match "resume_books/:id/download_iso" => "resume_books#download_iso", via: :get, :as => :resume_book_download_iso
  match "resume_books/missing" => "resume_books#missing", via: :post, :as => :resume_book_missing
  match "resume_books/missing" => "resume_books#missing", via: :get, :as => :resume_book_missing_get
  match 'resumes/include/:id' => "resumes#include", via: :post, :as => :resumes_include
  match 'resumes/exclude/:id' => "resumes#exclude", via: :post, :as => :resumes_exclude
  match 'staff_members_merge' => 'staff_members#merge', via: :get, as: :staff_members_merge
  match 'staff_members_merge' => 'staff_members#merge_post_setup', via: :post, as: :staff_members_merge_post
  match 'staff_members_commit' => 'staff_members#merge_post_commit', via: :post, as: :staff_members_merge_post_commit
  match 'autocomplete_staff_members', to: 'staff_members#autocomplete_staff_members_name', via: :get, as: :autocomplete_staff_members_name

  match 'autocomplete_course_names', to: 'courses#autocomplete_course_names', via: :get, as: :autocomplete_course_name

  match "coursesurveys/course/:dept/:name", to: "coursesurveys#show", via: :get, :as => :coursesurveys_course
  match "coursesurveys/course/:dept", to: "coursesurveys#department", via: :get, :as => :coursesurveys_department
  match "coursesurveys/how-to", to: "pages#coursesurveys_how_to", via: :get, :as => :coursesurveys_how_to
  match "coursesurveys/info-profs", to: "pages#coursesurveys_info_profs", via: :get, :as => :coursesurveys_info_profs
  match "coursesurveys/ferpa", to: "pages#coursesurveys_ferpa", via: :get, :as => :coursesurveys_ferpa

  match 'staff_members/staff/:instructors', to: 'staff_members#instructors', via: :get, as: :staff_member_instructors

  resources :alum
  resources :announcements
  resources :challenges, only: [:create, :update, :index]
  resources :companies
  resources :contacts
  resources :courses
  resources :coursesurveys
  resources :dept_tours
  resources :exams
  resources :indrel_event_types
  resources :indrel_events
  resources :locations
  resources :resumes
  resources :resume_books, except: [:edit, :update]
  resources :resume_book_urls
  resources :staff_members
  resources :users, except: [:new, :create, :index]

  scope "events" do
    match "leaderboard(/:semester)", to: "events#leaderboard", via: :get, as: :event_leaderboard
    match "rsvps", to: "rsvps#my_rsvps", via: :get, as: :my_rsvps
    match "calendar", to: "events#calendar", via: :get, as: "events_calendar"
    match ":category", to: "events#index", via: :get, as: :events_category, constraints: {:category => /(future|past)/}
    # Routes for RSVP confirmation page
    match "confirm_rsvps/:role" => "events#confirm_rsvps_index", via: :get, :as => :confirm_rsvps_index
    match "confirm_rsvps/:role/event/:id" => "events#confirm_rsvps", via: :get, :as => :confirm_rsvps
    match "confirm/:id" => "rsvps#confirm", via: :get, :as => :confirm_rsvp
    match "unconfirm/:id" => "rsvps#unconfirm", via: :get, :as => :unconfirm_rsvp
    match "reject/:id" => "rsvps#reject", via: :get, :as => :reject_rsvp
  end

  resources :events do
    resources :rsvps, shallow: true
  end

  scope "candidate" do
    match "quiz", to: "candidate#quiz", via: :get, as: "candidate_quiz"
    match "submit_quiz", to: "candidate#submit_quiz", via: :post, as: "candidate_submit_quiz"
    match "portal", to: 'candidate#portal', via: :get, as: "candidate_portal"
    match "application", to: 'candidate#application', via: :get, as: "candidate_application"
    match "application", to: 'candidate#submit_app', via: :post, as: "candidate_submit_app"
    match "autocomplete_officer_name", to: "candidate#autocomplete_officer_name", via: :get, as: "autocomplete_officer_name"
  end

  scope "indrel" do
    match "/", to: "indrel#why_hkn", via: :get, as: "indrel"
    match "contact_us", to: "indrel#contact_us", via: :get, as: "indrel_contact_us"
    match "career_fair", to: "indrel#career_fair", via: :get, as: "career_fair"
    match "resume_books", to: "indrel#resume_books", via: :get, as: "resume_books_about"
    match "resume_books/order", to: "indrel#resume_books_order", via: :get, :as => "resume_books_order"
    match "resume_books/order", to: "indrel#resume_books_transaction_id", via: :post, :as => "resume_books_transaction_id"
    match "resume_books/success", to: "indrel#resume_books_order_paypal_success", via: :get, :as => "resume_books_paypal_success"

    scope "infosessions" do
      match "/", to: "infosession_requests#about", via: :get, as: "infosessions"
      match "registration", to: "infosession_requests#new", via: :get, as: "new_infosession_request"
      match "registration", to: "infosession_requests#create", via: :post, as: "create_infosession_request"
    end
  end

  #About HKN
  scope 'about' do
    match 'contact', to: "pages#contact", via: :get, as: "about_contact"
    match 'officers(/:semester)', to: "pages#officers", via: :get, as: "about_officers"
    match 'committee_members(/:semester)', to: "pages#committee_members", via: :get, as: "about_committee_members"
  end

  scope 'bridge' do
    resources :slideshows
    resources :yearbooks
  end

  namespace :admin do
    scope "csec" do
      match "/", to: "csec#index", via: :get, as: :csec
      match "select_classes", to: "csec#select_classes", via: :get, as: :csec_select_classes
      match "select_classes", to: "csec#select_classes_post", via: :post, as: :csec_select_classes_post
      match "manage_classes", to: "csec#manage_classes", via: :get, as: :csec_manage_classes
      match "manage_classes", to: "csec#manage_classes_post", via: :post, as: :csec_manage_classes_post
      match "manage_candidates", to: "csec#manage_candidates", via: :get, as: :csec_manage_candidates
      match "upload_surveys", to: "csec#upload_surveys", via: :get, as: :csec_upload_surveys
      match "upload_surveys", to: "csec#upload_surveys_post", via: :post, as: :csec_upload_surveys_post
      match 'coursesurveys/:id', to: 'csec#coursesurvey_show', via: :get, as: :csec_coursesurvey
      match 'coursesurveys/:coursesurvey_id/remove/:user_id', to: 'csec#coursesurvey_remove', via: :delete, as: :csec_coursesurvey_remove
    end
    scope "vp" do
      match "/", to: "vp#index", via: :get, as: :vp
      match "applications", to: "vp#applications", via: :get, as: :cand_applications
      match "applications/byperson", to: "vp#byperson", via: :get, as: :cand_byperson
      match "applications/bycommittee", to: "vp#bycommittee", via: :get, as: :cand_bycommittee
      match "applications/byperson_withoutapp", to: "vp#byperson_without_application", via: :get, as: :cand_byperson_without_application
      match "super_page(/:semester)", to: "vp#super_page", via: :get, as: :vp_super_page
      match "promote_candidate_path", to: "vp#promote_candidate", via: :post, as: :vp_promote_candidate
    end
    match "pres", to: "pres#index", via: :get, as: :pres
    scope "bridge" do
      match "/", to: "bridge#index", via: :get, as: :bridge
      match "officer_photo_upload", to: "bridge#officer_photo_index", via: :get, as: :bridge_officer_index
      match "officer_photo_upload", to: "bridge#officer_photo_upload", via: :post, as: :bridge_officer_upload
    end
    scope "indrel" do
      match "/", to: "indrel#index", via: :get, as: :indrel
    end
    scope "studrel" do
      match "/", to: "studrel#index", via: :get, as: :studrel
    end
  end

end
