class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :require_session!
  before_action :populate_whodunnit

  def require_session!
    unless valid_session?
      redirect_to '/login'
    end
  end

  def group_slug
    Rails.application.config.group_slug
  end

  def populate_whodunnit
    PaperTrail.request.whodunnit = session[:uid]
  end
end
