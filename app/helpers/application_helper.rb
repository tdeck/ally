module ApplicationHelper
  def valid_session?
    session[:credentials].symbolize_keys! # TODO
    if session[:credentials].nil?
      return false
    elsif session[:credentials][:expires_at] <= Time.now.to_i
      session.delete(:credentials) # Wipe out expired credentials
      return false
    end
    true
  end

  def oauth_token
    session[:credentials][:token]
  end
end
