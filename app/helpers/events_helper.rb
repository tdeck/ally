module EventsHelper
  def short_date(event)
    Time.at(event[:time] / 1000).strftime("%-m/%-d")
  end
end
