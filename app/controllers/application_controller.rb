class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :require_session!
  before_action :populate_whodunnit

  def require_session!
    unless valid_session?
      if request.method_symbol == :get
        redirect_to login_path(origin: request.fullpath)
      else
        redirect_to '/login', alert:
          'Your session expired and had to be refreshed. '\
          'Try the back button to get your submission back.'
      end
    end
  end

  def group_slug
    Rails.application.config.group_slug
  end

  def populate_whodunnit
    PaperTrail.request.whodunnit = session[:uid]
  end
end
