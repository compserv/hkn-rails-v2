HknRails::Application.routes.draw do
  get 'dept_tours/success' => 'dept_tours#success', as: 'dept_tours_success'
  resources :dept_tours

  resources :exams

  resources :challenges, only: [:create, :update, :index]

  devise_for :users

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'
  get 'candidate/autocomplete_officer_name' => 'candidate#autocomplete_officer_name', as: 'autocomplete_officer_name'

  root to: "pages#home"
end
