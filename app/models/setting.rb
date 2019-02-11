# == Schema Information
#
# Table name: settings
#
#  id         :bigint(8)        not null, primary key
#  key        :string(255)
#  value      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#

class Setting < ApplicationRecord
  has_paper_trail

  # These class methods are the API you should be using
  class << self
    def get_str(key)
      find_by_key(key)&.value
    end

    def set_str!(key, value)
      s = find_or_initialize_by(key: key)
      s.value = value
      s.save!

      nil # Shouldn't rely on a return value here
    end
  end
end
