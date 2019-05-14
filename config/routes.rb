Rails.application.routes.draw do
  get 'sessions/new'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :stats do
  #  collection do
  #    get 'refresh'
  #  end
  #end
  resources :users
  resources :static
  get 'stats', to: "users#index", as: "stats"
  get 'instructions', to: "static#instructions", as: "instructions"
  #get 'twofactor', to: "static#twofactor", as: "twofactor"
  get 'registration', to: "registration#register", as: "registration"
  get    '/register',   to: 'sessions#register'
  post    '/register',   to: 'sessions#register_create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  root 'welcome#index'
  #get "/:page" => "static#show"
end
