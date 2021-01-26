# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_21_135109) do

  create_table "fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "form_drafts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "intro_text"
    t.integer "form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "email"
    t.string "reply_to"
  end

  create_table "forms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "intro_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
    t.string "reply_to"
    t.string "slug"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.boolean "staff"
    t.string "spire"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

end
