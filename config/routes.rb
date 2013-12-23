HknRails::Application.routes.draw do
  resources :challenges, only: [:create, :update, :index]

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'

  root to: "pages#home"
end
