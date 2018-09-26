# == Schema Information
#
# Table name: cross_posts
#
#  id            :bigint(8)        not null, primary key
#  dest_meetup   :string(255)
#  source_meetup :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  dest_id       :string(255)
#  source_id     :string(255)
#

class CrossPost < ApplicationRecord
end
