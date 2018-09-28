class CrossPostsController < ApplicationController
  before_action :require_session

  def new
    @source_group = Rails.application.config.group_slug
    @event_id = params[:event_id]
  end

  def create
    post = CrossPostEventJob.perform_now(
      params.require(:source_group),
      params.require(:event_id), 
      params.require(:dest_group),
      oauth_token
    )
    redirect_to cross_post_path(post)
  end

  def show
    @post = CrossPost.find_by_id!(params[:id])
  end
end
