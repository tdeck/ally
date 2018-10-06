class MeetupClient
  def initialize(oauth_token)
    @oauth_token = oauth_token
  end

  def list_managed_groups(uid)
    res = RestClient.get(
      "https://api.meetup.com/members/self",
      Authorization: "Bearer #{@oauth_token}",
      params: {
        fields: 'memberships',
      },
      accept: :json,
    )

    JSON.parse(res.body)['memberships']['organizer']
      .map { |g| g['group'].with_indifferent_access }
  end

  def list_upcoming_events(group, count)
    res = RestClient.get(
      "https://api.meetup.com/#{group}/events",
      params: {
        page: count,
        scroll: 'next_upcoming',
      },
      Authorization: "Bearer #{@oauth_token}",
      accept: :json,
    )

    JSON.parse(res.body).map(&:with_indifferent_access)
  end

  def list_rsvps(group, event_id)
    res = RestClient.get(
      "https://api.meetup.com/#{group}/events/#{event_id}/rsvps",
      params: {
        response: 'yes', # Include only "yes" RSVPs
        fields: 'answers', # Docs don't say you need this but you do
      },
      Authorization: "Bearer #{@oauth_token}",
      accept: :json,
    )

    JSON.parse(res.body).map(&:with_indifferent_access)
  end
end
