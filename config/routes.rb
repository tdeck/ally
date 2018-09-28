Rails.application.routes.draw do
  resources :cross_posts
  get 'events/list'

  # OAuth routes
  get   '/login', :to => 'sessions#new', :as => :login
  get   '/logout', :to => 'sessions#destroy', :as => :logout
  get '/auth/:provider/callback', :to => 'sessions#create' # TODO match?
  get '/auth/failure', :to => 'sessions#failure' # TODO match?
end
