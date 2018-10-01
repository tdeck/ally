class MeetupClient
  def initialize(oauth_token)
    @oauth_token = oauth_token
  end

  def list_upcoming_events(group, count)
    res = RestClient.get(
      "https://api.meetup.com/#{Rails.application.config.group_slug}/events",
      params: {
        page: count,
        scroll: 'next_upcoming',
      },
      Authorization: "Bearer #{@oauth_token}",
      accept: :json,
    )

    JSON.parse(res.body).map(&:with_indifferent_access)
  end
end
