class CreateMeetupEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :meetup_events do |t|
      t.string :muid, limit: 32
      t.string :name
      t.string :status
      t.datetime :start_time
      t.string :deail_sha

      t.timestamps
    end
    add_index :meetup_events, :muid, unique: true
  end
end
