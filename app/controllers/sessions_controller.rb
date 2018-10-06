class SessionsController < ApplicationController
  skip_before_action :require_session!

  def new
    redirect_to '/auth/meetup'
  end

  def create
    auth = request.env['omniauth.auth']

    session['uid'] = auth.uid
    session['credentials'] = auth.credentials

    redirect_to controller: 'events', action: 'index'
  end

  def failure
  end

  def destroy
    reset_session
    redirect_to action: :new
  end

  # TODO logout action
end
