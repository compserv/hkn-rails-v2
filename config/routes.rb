HknRails::Application.routes.draw do

  root to: "pages#home"

  devise_for :users, controllers: { registrations: "registrations" }

  match "about/contact", to: "pages#contact", via: :get, as: "contact"
  match "about/officers(/:semester)", to: "pages#officers", via: :get, as: "about_officers"
  match "about/committee_members(/:semester)", to: "pages#committee_members", via: :get, as: "about_committee_members"


  match "dept_tours/success", to: "dept_tours#success", via: :get, as: "dept_tours_success"
  match "dept_tours/:id", to: "dept_tours#respond_to_tour", via: :post
  match "users/approve/:id", to: "users#approve", via: :post, as: "users_approve"
  match "users/list(/:category)", to: "users#list", via: :get, as: "users_list"
  match "users/roles/:id", to: "users#roles", via: :get, as: "edit_roles_user"
  match "users/roles/:id", to: "users#alter_roles", via: :post, as: "alter_roles_user"
  match "resumes/upload_for/:id" => "resumes#upload_for", via: :get, :as => :resumes_upload_for

  resources :alum
  resources :challenges, only: [:create, :update, :index]
  resources :dept_tours
  resources :exams
  resources :resumes
  resources :users, except: [:new, :create, :index]

  scope "events" do
    match "rsvps", to: "rsvps#my_rsvps", via: :get, as: :my_rsvps
    match "calendar", to: "events#calendar", via: :get, as: "events_calendar"
    match ":category", to: "events#index", via: :get, as: :events_category, constraints: {:category => /(future|past)/}
    # Routes for RSVP confirmation page
    match "confirm_rsvps/:group" => "events#confirm_rsvps_index", via: :get, :as => :confirm_rsvps_index
    match "confirm_rsvps/:group/event/:id" => "events#confirm_rsvps", via: :get, :as => :confirm_rsvps    
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
    match "autocomplete_officer_name", to: "candidate#autocomplete_officer_name", via: :get, as: "autocomplete_officer_name"
  end

  scope "indrel" do
    match "/", to: "indrel#why_hkn", via: :get, as: "indrel"
    match "contact_us", to: "indrel#contact_us", via: :get, as: "indrel_contact_us"
    match "career_fair", to: "indrel#career_fair", via: :get, as: "career_fair"
    match "resume_books", to: "indrel#resume_books", via: :get, as: "resume_books_about"

    scope "infosessions" do
      match "/", to: "infosession_requests#about", via: :get, as: "infosessions"
      match "registration", to: "infosession_requests#new", via: :get, as: "new_infosession_request"
      match "registration", to: "infosession_requests#create", via: :post, as: "create_infosession_request"
    end
  end

  namespace :admin do
    scope "vp" do
      match "/", to: "vp#index", via: :get, as: :vp
    end
    scope "bridge" do
      match "/", to: "bridge#index", via: :get, as: :bridge
      match "officer_photo_upload", to: "bridge#officer_photo_index", via: :get, as: :bridge_officer_index
      match "officer_photo_upload", to: "bridge#officer_photo_upload", via: :post, as: :bridge_officer_upload
    end
  end

end
