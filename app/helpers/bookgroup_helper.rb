module BookgroupHelper
  EVENT_NAME_PATTERN = /Humanist Book Group/i
  ROOM_TITLE_AUTHOR_PATTERN = /Join us (in the (?<room>\w+ room)|.*) as we discuss "(?<title>[^"]+)" by (?<author>.+?)\./

  def matches_bookgroup_pattern?(event)
    event[:name].match?(EVENT_NAME_PATTERN) && \
      event[:plain_text_description].match?(ROOM_TITLE_AUTHOR_PATTERN)
  end

  def book_group_email_details(event)
    time = Time.at(event[:time] / 1000)
    date = time.to_date

    m = event[:plain_text_description].match(ROOM_TITLE_AUTHOR_PATTERN)

    if m[:room].present?
      has_unusual_location = false
      location = "#{m[:room]}, Main Library"
     else
      has_unusual_location = true
      location = "#{event[:venue][:name]}, #{event[:venue][:address_1]}" +
          if event[:how_to_find_us].present?
            " (#{event[:how_to_find_us]})"
          else
            ''
          end
     end
    {
      book_title: m[:title],
      short_title: m[:title].split(':').first, # A rough heuristic
      author: m[:author],
      online_event: event[:is_online_event],
      location: location,
      event_url: event[:link],
      weekday: time.strftime("%A"),
      date_str: time.strftime("%B #{time.day.ordinalize}"),
      time_str: time.strftime('%l:%M %p'), # This has a left space but it's OK
      has_unusual_location: has_unusual_location,
    }
  end
end
