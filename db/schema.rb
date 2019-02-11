# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_11_024353) do

  create_table "cross_posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "source_meetup"
    t.string "source_id"
    t.string "dest_meetup"
    t.string "dest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_link"
  end

  create_table "image_uploads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sha1", limit: 40, null: false
    t.string "title"
    t.binary "bytes", limit: 16777215, null: false
    t.string "mime_type", null: false
    t.string "creator_uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sha1"], name: "index_image_uploads_on_sha1", unique: true
  end

  create_table "meetup_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "muid", limit: 32
    t.string "name"
    t.string "status"
    t.datetime "start_time"
    t.string "deail_sha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["muid"], name: "index_meetup_events_on_muid", unique: true
  end

  create_table "named_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "full_name"
    t.string "meetup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "non_meetup_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "location"
    t.date "start_date"
    t.date "end_date"
    t.text "description_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
