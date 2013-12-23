HknRails::Application.routes.draw do
  resources :challenges

  get 'candidate/portal' => 'candidate#portal', as: 'candidate_portal'


  root to: "pages#home"
end
