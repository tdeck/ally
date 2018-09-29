class CrossPostsController < ApplicationController
  before_action :require_session

  def new
    @source_group = Rails.application.config.group_slug
    @event_id = params[:event_id]
  end

  def create
    task = params.require(:task)

    source_group = params.require(:source_group)
    event_id = params.require(:event_id)

    if task == 'generate'
      post = CrossPostEventJob.perform_now(
        source_group,
        event_id,
        params.require(:dest_group),
        oauth_token
      )
    elsif task == 'record'
      copy_id = params.require(:copy_event_id)
      if copy_id == event_id
        raise "Copy ID same as source ID"
      end

      # To make things easier on the user, we only require the event ID
      # and not the group URL name. We have to use the older v2 endpoint
      # to retrieve the event without the group URL name.
      res = RestClient.get(
        "https://api.meetup.com/2/events",
        params: {
          page: 1,
          event_id: copy_id,
        },
        Authorization: "Bearer #{oauth_token}",
        accept: :json,
      )
      payload = JSON.parse(res.body).with_indifferent_access

      if payload[:meta][:total_count] > 1
        raise "Found more than one event for ID #{copy_id}"
      end

      copy_fields = payload[:results][0] # TODO handle not found

      post = CrossPost.create!(
        source_meetup: source_group,
        dest_meetup: copy_fields[:group][:urlname],
        source_id: event_id,
        dest_id: copy_id,
        post_link: copy_fields[:event_url],
      )
    else
      raise "Unknown task #{task}"
    end

    redirect_to cross_post_path(post)
  end

  def show
    @post = CrossPost.find_by_id!(params[:id])
  end
end
