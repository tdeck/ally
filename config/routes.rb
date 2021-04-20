Rails.application.routes.draw do
  get '/', :to => 'home#index'

  resources :events, only: [:index, :show] do
    resources :cross_posts, only: [:new, :create]
  end

  resources :named_users, only: [:create]

  resources :newsletters, only: [:new, :create]
  resources :non_meetup_events, only: [:new, :create]
  resources :image_uploads
  resources :badge_printouts, only: [:new, :create]

  resources :settings, only: [:index, :show] do
    collection do
      patch '' => 'settings#update_all'
    end
  end

  # OAuth routes
  get '/login', :to => redirect(path: '/auth/meetup'), :as => :login
  get '/logout', :to => 'sessions#destroy', :as => :logout
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/session', :to => 'sessions#get'
end
