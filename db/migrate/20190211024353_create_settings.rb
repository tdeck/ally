class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :key, required: true, limit: 191 # Max index length
      t.string :value

      t.timestamps
    end
    add_index :settings, :key, unique: true
  end
end
