class EventsController < ApplicationController
  NUM_EVENTS = 10

  def index
    @events = meetup_client.list_upcoming_events(group_slug, NUM_EVENTS)
  end

  def show
    id = params.require(:id)

    res = RestClient.get(
      "https://api.meetup.com/#{group_slug}/events/#{id}",
      Authorization: "Bearer #{oauth_token}",
      accept: :json,
    )

    @event = JSON.parse(res.body).with_indifferent_access
    # TODO maybe weed out deleted ones

    @cross_posts = CrossPost.where(
      source_meetup: @event[:group][:urlname],
      source_id: id,
    )

    raw_rsvps = (
      meetup_client.list_rsvps(group_slug, id) +
      @cross_posts.flat_map { |cp| meetup_client.list_rsvps(cp.dest_meetup, cp.dest_id) }
    )

    @rsvps = raw_rsvps.uniq {|r| r[:member][:id] }.map do |r|
      uid = r[:member][:id]
      answer_string = r.dig(:answers, 0, :answer)

      {
        uid: uid,
        name: r[:member][:name],
        answer: answer_string.present? ? answer_string : nil,
        verified_name: NamedUser.find_by_meetup_id(uid)&.full_name,
        plus: r[:guests],
      }
    end.sort { |p, q| p[:name].casecmp(q[:name]) }

    @rsvp_count = @rsvps.count + @rsvps.map {|r| r[:plus] }.sum
  end
end
