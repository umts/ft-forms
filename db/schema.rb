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

ActiveRecord::Schema.define(version: 20170414155904) do

  create_table "fields", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "number"
    t.text "prompt"
    t.string "data_type"
    t.integer "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "required"
    t.text "options"
    t.integer "form_draft_id"
    t.string "placeholder"
  end

  create_table "form_drafts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.text "intro_text"
    t.integer "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "email"
    t.string "reply_to"
  end

  create_table "forms", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.text "intro_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
    t.string "reply_to"
    t.string "slug"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "first_name"
    t.string "last_name"
    t.boolean "staff"
    t.string "spire"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

end
