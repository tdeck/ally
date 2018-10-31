# == Schema Information
#
# Table name: non_meetup_events
#
#  id               :bigint(8)        not null, primary key
#  description_html :text(65535)
#  end_date         :date
#  location         :string(255)
#  start_date       :date
#  title            :string(255)
#  url              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class NonMeetupEvent < ApplicationRecord
  scope :not_ended, -> { where('end_date >= ?', Date.today) }

  def present
    # For now we don't have a good way of displaying date ranges spanning
    # months so we just display the first date
    if start_date == end_date || start_date.month != end_date.month
      mday = start_date.mday.to_s
      wday = start_date.strftime('%A')
    else 
      mday = "#{start_date.mday}-#{end_date.mday}"
      wday = "#{start_date.strftime('%a')}-#{end_date.strftime('%a')}"
    end

    {
      id: munged_id,
      url: url,
      title: title,
      month: start_date.strftime('%B'),
      mday: mday,
      wday: wday,
      location: location,
      description_html: description_html,
    }
  end

  def munged_id
    "nme-#{id}"
  end
end
