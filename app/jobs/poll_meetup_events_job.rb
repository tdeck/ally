class PollMeetupEventsJob < ApplicationJob
  queue_as :default

  # NOTE: If you change the fields here, that will invalidate all the old digests
  # and you'll get an update for every meetup event.
  DETAIL_DIGEST_FIELDS = [
    # Keep sorted
    :description, 
    :duration,
    :how_to_find_us,
    :name,
    :time,
    :venue, # This is a data structure
    :venue_visibility, # This could be important
  ]

  def perform
    # Do something later
  end
end
