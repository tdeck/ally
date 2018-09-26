class CreateCrossPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :cross_posts do |t|
      t.string :source_meetup
      t.string :source_id
      t.string :dest_meetup
      t.string :dest_id

      t.timestamps
    end
  end
end
