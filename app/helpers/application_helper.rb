module ApplicationHelper
  def valid_session?
    if session[:credentials].nil?
      return false
    elsif session[:credentials][:expires_at] <= Time.now.to_i
      session.delete(:credentials) # Wipe out expired credentials
      return false
    end
    true
  end
end
