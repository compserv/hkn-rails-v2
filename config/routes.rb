HknRails::Application.routes.draw do
  resources :alum
  
  resources :resumes

  get 'dept_tours/success' => 'dept_tours#success', as: 'dept_tours_success'
  post 'dept_tours/:id' => 'dept_tours#respond_to_tour'
  resources :dept_tours

  resources :exams

  resources :challenges, only: [:create, :update, :index]

  devise_for :users
  resources :users
  get 'users/list/:filter' => 'users#list', as: 'users_list'

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'
  get 'candidate/autocomplete_officer_name' => 'candidate#autocomplete_officer_name', as: 'autocomplete_officer_name'

  root to: "pages#home"
  get 'about/contact' => 'pages#contact'

  #Indrel
  scope 'indrel' do
    match "/", to: "indrel#why_hkn", via: 'get', as: 'indrel'
    match "contact_us", to: "indrel#contact_us", via: 'get', as: 'indrel_contact_us'
    match "career_fair", to: "indrel#career_fair", via: 'get', as: 'career_fair'
    match 'infosessions', to: "indrel#infosessions", via: 'get'
    match 'resume_books', to: "indrel#resume_books", via: 'get', as: "resume_books_about"
  end

end
