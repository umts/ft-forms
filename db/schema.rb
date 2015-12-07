# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151204165537) do

  create_table "fields", force: :cascade do |t|
    t.integer  "number",        limit: 4
    t.text     "prompt",        limit: 65535
    t.string   "data_type",     limit: 255
    t.integer  "form_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "required"
    t.text     "options",       limit: 65535
    t.integer  "form_draft_id", limit: 4
    t.string   "placeholder",   limit: 255
  end

  create_table "form_drafts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "intro_text", limit: 65535
    t.integer  "form_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
    t.string   "email",      limit: 255
    t.string   "reply_to",   limit: 255
  end

  create_table "forms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "intro_text", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      limit: 255
    t.string   "reply_to",   limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.boolean  "staff"
    t.string   "spire",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "email",      limit: 255
  end

end
