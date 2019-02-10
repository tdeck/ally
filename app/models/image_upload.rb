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
  # This model stores image uploads in the database. Performance-wise that's
  # not the best choice, but it means there's one thing that needs to be
  # backed up or moved if we change hosts, and for this kind of deployment
  # that simplicity is valuable. Currently our traffic demands are not
  # at all significant.

  def to_param
    sha1
  end
end
