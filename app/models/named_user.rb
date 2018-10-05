# == Schema Information
#
# Table name: named_users
#
#  id         :bigint(8)        not null, primary key
#  full_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  meetup_id  :string(255)
#

class NamedUser < ApplicationRecord
end
