class EventsController < ApplicationController
  NUM_EVENTS = 10

  before_action :require_session

  def index
    @events = meetup_client.list_upcoming_events(Rails.application.config.group_slug, NUM_EVENTS)
  end

  def show
    id = params.require(:id)

    res = RestClient.get(
      "https://api.meetup.com/#{Rails.application.config.group_slug}/events/#{id}",
      Authorization: "Bearer #{oauth_token}",
      accept: :json,
    )

    @event = JSON.parse(res.body).with_indifferent_access
    # TODO maybe weed out deleted ones
    @cross_posts = CrossPost.where(
      source_meetup: @event[:group][:urlname],
      source_id: id,
    )
  end
end
