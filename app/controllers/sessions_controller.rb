class SessionsController < ApplicationController
  skip_before_action :require_session!

  def create
    auth = request.env['omniauth.auth']

    uid = auth.uid

    email = MeetupClient.new(auth.credentials['token']).get_user_email

    unless admin_emails.include?(email.downcase)
      return redirect_to '/', alert: "This meetup user #{email} is not authorized to use Ally. Contact the Ally administrator for access."
    end

    session['uid'] = uid
    session['email'] = email
    session['credentials'] = auth.credentials

    redirect_to request.env['omniauth.origin'] || { controller: 'events', action: 'index' }
  end

  def get
    render json: {
      valid: valid_session?,
      near_expiry: session_near_expiry?
    }
  end

  def failure
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  def admin_emails
    (Setting.get_str(SettingsKeys::ADMIN_EMAILS) || '').strip.downcase.split(/\r?\n/) +
      Rails.application.config.sysadmin_emails
  end
end
