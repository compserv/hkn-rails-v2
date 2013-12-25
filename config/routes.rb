HknRails::Application.routes.draw do
  resources :exams

  resources :challenges, only: [:create, :update, :index]

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'
  get 'candidate/autocomplete_officer_name' => 'candidate#autocomplete_officer_name', as: 'autocomplete_officer_name'

  root to: "pages#home"
end
