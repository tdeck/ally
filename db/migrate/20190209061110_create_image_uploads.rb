class CreateImageUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :image_uploads do |t|
      t.string :sha1, null: false, limit: 40 # hex SHA1 length
      t.string :title
      t.binary :bytes, null: false, limit: 10.megabyte # Just a sanity limit; no particular reason for 10 MB
      t.string :mime_type, null: false
      t.string :creator_uid, null: false

      t.timestamps
    end
    add_index :image_uploads, :sha1, unique: true
  end
end
