class NewslettersController < ApplicationController
   include ActionView::Helpers::TextHelper
  NUM_EVENTS = 10
  STYLESHEET_FILES = ['email.css', 'time.css']

  def new
    @templated_events = meetup_client
      .list_upcoming_events(Rails.application.config.group_slug, NUM_EVENTS)
      .map { |event|
        time = Time.parse(event[:dateTime])
        {
          id: event[:id],
          url: event[:eventUrl],
          title: event[:title],
          month: time.strftime('%B'),
          mday: time.mday,
          wday: time.strftime('%A'),
          location: format_location(event),
          description_html: simple_format(event[:description]),
        }
      } + NonMeetupEvent.not_ended.order(:start_date).map(&:present)
  end

  def create
    sections = params.require(:sections)[0] # id -> section # TODO understand what [0] does

    hero_image_upload = store_image_upload(
      params.require(:hero_image),
      title: params.require(:hero_alt)
    )

    other_events = params.require(:events).select { |e| sections[e[:id]] == 'others' }.map(&:permit!)

    template_params = {
      main_title: params.require(:main_title),
      hero_url: image_upload_url(hero_image_upload),
      hero_alt: params.require(:hero_alt),
      lead_html: params.require(:lead_html),
      our_events: params.require(:events).select { |e| sections[e[:id]] == 'ours' }.map(&:permit!),
      other_events: other_events,
      has_other_events: other_events.any?,
      articles: params.require(:articles).select { |a| a[:title].present? }.map(&:permit!),
    }

    premailer = Premailer.new(
      Mustache.render(email_template, template_params),
      with_html_string: true,
      css_to_attributes: false,
      css_string: email_css, # TODO check if this is the best way
    )

    @newsletter_html = premailer.to_inline_css

    render layout: false # Don't include extra CSS that might mess up the email (until all:revert works)
  end

  def format_location(event)
    venue = event[:venue]
    return '' if venue.nil?
    return venue.fetch(:name, '') if not venue[:address_1]
    venue[:name] + ', ' + venue[:address_1] + (venue[:city] == 'San Francisco' ? '' : venue[:city])
  end

  def email_template
    @email_template ||= File.read(File.join(Rails.root, 'data', 'newsletter.mustache'))
  end

  def email_css
    @email_css ||= STYLESHEET_FILES.map { |file|
      File.read(File.join(Rails.root, 'data', file))
    }.join("\n")
  end
end
