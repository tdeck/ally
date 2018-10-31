class CreateNonMeetupEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :non_meetup_events do |t|
      t.string :url, required:true
      t.string :title, required: true
      t.string :location
      t.date :start_date, required: true
      t.date :end_date, required: true
      t.text :description_html, required: true

      t.timestamps
    end
  end
end
