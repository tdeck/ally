class SessionsController < ApplicationController
  skip_before_action :require_session!

  def new
    redirect_to '/auth/meetup'
  end

  def create
    auth = request.env['omniauth.auth']

    uid = auth.uid
    raise 'Wrong uid type' unless uid.is_a?(Integer)

    email = MeetupClient.new(auth.credentials['token']).get_user_email

    unless Rails.application.config.admin_emails.include?(email.downcase)
      return redirect_to '/', alert: "This meetup user #{email} is not authorized to use Ally. Contact the Ally administrator for access."
    end

    session['uid'] = uid
    session['email'] = email
    session['credentials'] = auth.credentials

    redirect_to controller: 'events', action: 'index'
  end

  def failure
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  # TODO logout action
end
