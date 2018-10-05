class CreateNamedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :named_users do |t|
      t.string :full_name
      t.string :meetup_id, unique: true

      t.timestamps
    end
  end
end
