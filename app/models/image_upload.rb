# == Schema Information
#
# Table name: image_uploads
#
#  id          :bigint(8)        not null, primary key
#  bytes       :binary(16777215) not null
#  creator_uid :string(255)      not null
#  mime_type   :string(255)      not null
#  sha1        :string(40)       not null
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_image_uploads_on_sha1  (sha1) UNIQUE
#

class ImageUpload < ApplicationRecord

  def to_param
    sha1
  end
end
