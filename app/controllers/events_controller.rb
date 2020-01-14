class EventsController < ApplicationController
  include BookgroupHelper

  NUM_EVENTS = 10
  CHAT_BASE_URL = 'https://secure.meetup.com/messages/'
  BOOK_ANNOUNCEMENT_EMAIL_SUBJECT_TEMPLATE = 'Book Group {{{date_str}}}: {{{short_title}}}'
  BOOK_REMINDER_EMAIL_SUBJECT_TEMPLATE = 'Book Group this {{{weekday}}}'

  def index
    @upcoming_events = meetup_client.list_upcoming_events(group_slug, NUM_EVENTS)
    @recent_events = meetup_client.list_recent_past_events(group_slug, NUM_EVENTS)
  end

  def show
    id = params.require(:id)

    res = RestClient.get(
      "https://api.meetup.com/#{group_slug}/events/#{id}",
      Authorization: "Bearer #{oauth_token}",
      accept: :json,
      params: {
        fields: 'plain_text_description',
      },
    )

    @event = meetup_client.get_event(group_slug, id)

    @cross_posts = CrossPost.where(
      source_meetup: @event[:group][:urlname],
      source_id: id,
    ).map { |xp| CrossPostPresenter.new(xp, meetup_client) }

    raw_rsvps = (
      meetup_client.list_rsvps(group_slug, id) +
      @cross_posts.flat_map { |cp| meetup_client.list_rsvps(cp.dest_meetup, cp.dest_id) }
    )

    @rsvps = raw_rsvps.uniq {|r| r[:member][:id] }.map do |r|
      uid = r[:member][:id]
      answer_string = r.dig(:answers, 0, :answer)

      mu_name = r[:member][:name]

      {
        uid: uid,
        name: mu_name,
        answer: answer_string.present? ? answer_string : nil,
        verified_name: NamedUser.find_by_meetup_id(uid)&.full_name,
        plus: r[:guests],
        chat_link: "#{CHAT_BASE_URL}?new_convo=true&member_id=#{uid}&name=#{CGI::escape(mu_name)}"
      }
    end.sort { |p, q| p[:name].casecmp(q[:name]) }

    @rsvp_count = @rsvps.count + @rsvps.map {|r| r[:plus] }.sum

    @question_answers = raw_rsvps.map { |r| r.dig(:answers, 0, :answer) }.compact.uniq

    if matches_bookgroup_pattern?(@event)
      email_details = book_group_email_details(@event)

      @book_announcement_email_subject = Mustache.render(BOOK_ANNOUNCEMENT_EMAIL_SUBJECT_TEMPLATE, email_details)
      @book_announcement_email_html =  Mustache.render(book_announcement_email_template, email_details)

      @book_reminder_email_subject = Mustache.render(BOOK_REMINDER_EMAIL_SUBJECT_TEMPLATE, email_details)
      @book_reminder_email_html =  Mustache.render(book_reminder_email_template, email_details)
    end
  end

private

  def book_announcement_email_template
    @book_announcement_email_template ||= File.read(File.join(Rails.root, 'data/bookgroup_emails/announcement.mustache'))
  end

  def book_reminder_email_template
    @book_reminder_email_template ||= File.read(File.join(Rails.root, 'data/bookgroup_emails/reminder.mustache'))
  end
end
