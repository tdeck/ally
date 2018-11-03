class SessionsController < ApplicationController
  skip_before_action :require_session!

  def new
    redirect_to '/auth/meetup'
  end

  def create
    auth = request.env['omniauth.auth']

    uid = auth.uid
    raise 'Wrong uid type' unless uid.is_a?(Integer)

    unless Rails.application.config.admin_ids.include?(uid)
      # TODO show a proper error page
      raise 'This meetup user is not authorized to use Ally. Contact the Ally administrator for access.'
    end

    session['uid'] = uid
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
