Rails.application.routes.draw do
  get '/', :to => 'home#index'

  resources :events, only: [:index, :show] do
    resources :cross_posts, only: [:new, :create]
  end

  resources :named_users, only: [:create]

  resources :newsletters, only: [:new, :create]
  resources :non_meetup_events, only: [:new, :create]
  resources :image_uploads

  # OAuth routes
  get '/login', :to => 'sessions#new', :as => :login
  get '/logout', :to => 'sessions#destroy', :as => :logout
  get '/auth/:provider/callback', :to => 'sessions#create' # TODO match?
  get '/auth/failure', :to => 'sessions#failure' # TODO match?
end
