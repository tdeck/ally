Rails.application.routes.draw do
  resources :events, only: [:index, :show]
  resources :cross_posts, only: [:new, :create]

  resources :newsletters, only: [:new, :create]

  # OAuth routes
  get '/login', :to => 'sessions#new', :as => :login
  get '/logout', :to => 'sessions#destroy', :as => :logout
  get '/auth/:provider/callback', :to => 'sessions#create' # TODO match?
  get '/auth/failure', :to => 'sessions#failure' # TODO match?
end
