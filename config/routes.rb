Rails.application.routes.draw do
  root to: 'welcome#welcome'

  get    'login',  to: "sessions#new",       as: 'login'
  delete 'logout', to: "sessions#destroy",   as: 'logout'
  get    'signup', to: "users#new",          as: 'signup'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
