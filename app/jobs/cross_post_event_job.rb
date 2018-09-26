require 'rest-client'
require 'json'

# Cross-posts the given event to a new meetup, placing the new event in draft state
class CrossPostEventJob < ApplicationJob
  queue_as :default

  FIELDS_TO_COPY = {
    :name => ['name'],
    :description => ['simple_html_description'],
    :time => ['time'],
    :duration => ['duration'],
    :how_to_find_us => ['how_to_find_us'],

    :rsvp_limit => ['rsvp_limit'], # Naively copy even though this doesn't really set a total limit
    :guest_limit => ['rsvp_rules', 'guest_limit'],
    :rsvp_close_time => ['rsvp_rules', 'close_time'],
    :question => ['survey_questions', 0, 'question'], # TODO make this pull the latest always

    :lat => ['venue', 'lat'], # From venue -> lat
    :lon => ['venue', 'lon'], # From venue -> lon
    :venue_id => ['venue', 'id'], # From venue -> id
    :venue_visibility => ['venue_visibility'],
  }
  # TODO make images work
  # TODO maybe fees

  # Cross-posts an event, records it, and returns the created event's hash
  # Useful fields are :id and :link
  def perform(source_group, event_id, dest_group)
    res = RestClient.get(
      "https://api.meetup.com/#{source_group}/events/#{event_id}",
      params: {
        fields: 'how_to_find_us,rsvp_rules,answers,venue_visibility,survey_questions,simple_html_description',
        key: Rails.application.credentials.meetup_api_key,
      },
      accept: :json,
    )

    got_js = JSON.parse(res.body)

    # TODO check publish_status for 'published'
    # TODO Check visibility = 'public'

    put_js = {
      publish_status: 'draft',
    }

    FIELDS_TO_COPY.each do |key, path|
      value = got_js.dig(*path)
      if value != nil
        put_js[key] = value
      end
    end

    begin
      puts put_js.to_json
      res = RestClient.post(
        "https://api.meetup.com/#{dest_group}/events",
        put_js,
        content_type: :json,
        params: {
          key: Rails.application.credentials.meetup_api_key,
        }
      )

      result = JSON.parse(res.body).with_indifferent_access
      CrossPost.create!(
        source_meetup: source_group,
        source_id: event_id,
        dest_meetup: dest_group,
        dest_id: result[:id],
      )

      return result
    rescue RestClient::ExceptionWithResponse => e
      puts e.response.body
      throw e
    end
  end
end
