class SessionsController < ApplicationController
  def new
    redirect_to '/auth/meetup'
  end

  def create
    auth_hash = request.env['omniauth.auth']
   
    session[:credentials] = auth_hash[:credentials].symbolize_keys

    render :plain => "#{auth_hash.pretty_inspect}\n\n\n#{session[:credentials].pretty_inspect}\n\nvalid_session? #{valid_session?}"
  end

  def failure
  end

  # TODO logout action
end
