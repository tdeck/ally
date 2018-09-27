Rails.application.routes.draw do
  # OAuth routes
  get   '/login', :to => 'sessions#new', :as => :login
  get '/auth/:provider/callback', :to => 'sessions#create' # TODO match?
  get '/auth/failure', :to => 'sessions#failure' # TODO match?

end
