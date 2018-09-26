# == Schema Information
#
# Table name: meetup_events
#
#  id         :bigint(8)        not null, primary key
#  deail_sha  :string(255)
#  muid       :string(32)
#  name       :string(255)
#  start_time :datetime
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_meetup_events_on_muid  (muid) UNIQUE
#

class MeetupEvent < ApplicationRecord
end
