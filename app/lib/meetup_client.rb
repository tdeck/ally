class MeetupClient
  def initialize(oauth_token)
    @oauth_token = oauth_token
  end

  def get_user_email
    get_profile_info['email']
  end

  def get_profile_info
    res = RestClient.post(
      "https://api.meetup.com/gql",
      {query: ' query { self { id name email memberships { edges { node { name urlname } metadata { status role }}}}}'}.to_json,
      accept: :json,
      content_type: :json,
      Authorization: "Bearer #{@oauth_token}",
    )
    JSON.parse(res.body)['data']['self'].with_indifferent_access
  end

  def get_event(group, id)
    res = RestClient.get(
      "https://api.meetup.com/#{group}/events/#{id}",
      Authorization: "Bearer #{@oauth_token}",
      accept: :json,
      params: {
        fields: 'plain_text_description',
      },
    )

    JSON.parse(res.body).with_indifferent_access
  end

  def list_managed_groups
    get_profile_info['memberships']['edges']
      .select { |e| e['metadata']['status'] == 'LEADER' }
      .map { |e| e['node'].with_indifferent_access }
  end

  def list_upcoming_events(group, count)
    query = <<-END
      query ($groupslug: String!, $count: Int!) {
        groupByUrlname(urlname: $groupslug) {
          upcomingEvents(input: {first: $count}) {
            edges {
              node {
                id
                dateTime
                title
                eventUrl
                description
                isOnline
                venue {
                  name
                  address
                  city
                }
              }
            }
          }
        }
      }
    END

    res = RestClient.post(
      "https://api.meetup.com/gql",
      {query: query, variables: {groupslug: group, count: count}}.to_json,
      accept: :json,
      content_type: :json,
      Authorization: "Bearer #{@oauth_token}",
    )
    JSON.parse(res.body)['data']['groupByUrlname']['upcomingEvents']['edges'].map { |e| e['node'].with_indifferent_access }
  end

  def list_recent_past_events(group, count)
    list_events(group, page: count, scroll: 'recent_past', desc: true)
  end

  def list_events(group, **params)
    res = RestClient.get(
      "https://api.meetup.com/#{group}/events",
      params: params,
      Authorization: "Bearer #{@oauth_token}",
      accept: :json,
    )

    JSON.parse(res.body).map(&:with_indifferent_access)
  end

  def list_rsvps(group, event_id)
    # FYI: This will return 200 for draft events that the OAuth user does not
    # have access to
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
  rescue RestClient::Gone # If the event's been deleted it can't have RSVPs
    return []
  end
end
