class EventsController < ApplicationController
  NUM_EVENTS = 10

  before_action :require_session

  def list
    res = RestClient.get(
      "https://api.meetup.com/#{Rails.application.config.group_slug}/events",
      params: {
        page: NUM_EVENTS,
        scroll: 'next_upcoming',
      },
      Authorization: "Bearer #{oauth_token}",
      accept: :json,
    )
        
    @events = JSON.parse(res.body).map(&:with_indifferent_access)
  end
end
