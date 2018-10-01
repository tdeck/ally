class NewslettersController < ApplicationController
  NUM_EVENTS = 10
  STYLESHEET_FILES = ['email.css', 'time.css']

  def new
    @templated_events = meetup_client
      .list_upcoming_events(Rails.application.config.group_slug, NUM_EVENTS)
      .map { |event|
        time = Time.at(event[:time] / 1000)
        {
          url: event[:link],
          title: event[:name],
          month: time.strftime('%B'),
          mday: time.mday,
          wday: time.strftime('%A'),
          location: format_location(event),
          description: event[:description],
        }
      }
  end

  def create
    template_params = {
      main_title: params.require(:main_title),
      hero_url: params.require(:hero_url),
      hero_alt: params.require(:hero_alt),
      events: params.require(:events).select { |e| e[:included] }.map(&:permit!)
    }

    premailer = Premailer.new(
      Mustache.render(email_template, template_params),
      with_html_string: true,
      css_string: email_css, # TODO check if this is the best way
    )
    render html: premailer.to_inline_css.html_safe
  end

  def format_location(event)
    venue = event[:venue]
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
