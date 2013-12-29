HknRails::Application.routes.draw do
  resources :alumni
  
  resources :resumes

  get 'dept_tours/success' => 'dept_tours#success', as: 'dept_tours_success'
  post 'dept_tours/:id' => 'dept_tours#respond_to_tour'
  resources :dept_tours

  resources :exams

  resources :challenges, only: [:create, :update, :index]

  devise_for :users

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'
  get 'candidate/autocomplete_officer_name' => 'candidate#autocomplete_officer_name', as: 'autocomplete_officer_name'

  root to: "pages#home"
  get 'about/contact' => 'pages#contact'

  #Indrel
  scope 'indrel' do
    match "contact_us", to: "indrel#contact_us", via: 'get', as: 'indrel_contact_us'
  end
end
