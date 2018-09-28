class ApplicationController < ActionController::Base
  include ApplicationHelper

  def require_session
    unless valid_session?
      redirect_to '/login'
    end
  end
end
