class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :require_session!

  def require_session!
    unless valid_session?
      redirect_to '/login'
    end
  end

  def group_slug
    Rails.application.config.group_slug
  end
end
