module ApplicationHelper
  def valid_session?
    if session['uid'].nil? || session['credentials'].nil?
      return false
    elsif session['credentials']['expires_at'] <= Time.now.to_i
      session.delete('credentials') # Wipe out expired credentials
      return false
    end
    true
  end

  def oauth_token
    session['credentials']['token']
  end

  def meetup_client
    @meetup_client ||= MeetupClient.new(oauth_token)
  end
end
