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

ActiveRecord::Schema.define(version: 20150314171005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "akas", force: true do |t|
    t.integer  "song_id"
    t.string   "search_text"
    t.string   "display_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "akas", ["song_id"], name: "index_akas_on_song_id", using: :btree

  create_table "churches", force: true do |t|
    t.string   "church_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leaders", force: true do |t|
    t.string   "leader_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "church_id"
  end

  add_index "leaders", ["church_id"], name: "index_leaders_on_church_id", using: :btree

  create_table "service_types", force: true do |t|
    t.string   "service_type"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "church_id"
  end

  add_index "service_types", ["church_id"], name: "index_service_types_on_church_id", using: :btree

  create_table "services", force: true do |t|
    t.date     "date"
    t.integer  "leader_id"
    t.integer  "service_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "church_id"
  end

  add_index "services", ["church_id"], name: "index_services_on_church_id", using: :btree
  add_index "services", ["leader_id"], name: "index_services_on_leader_id", using: :btree
  add_index "services", ["service_type_id"], name: "index_services_on_service_type_id", using: :btree

  create_table "songs", force: true do |t|
    t.string   "song_name"
    t.string   "license"
    t.string   "writers"
    t.string   "lyrics_url"
    t.integer  "sof_number"
    t.string   "sample_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ccli_number"
  end

  create_table "usages", force: true do |t|
    t.integer  "song_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usages", ["service_id"], name: "index_usages_on_service_id", using: :btree
  add_index "usages", ["song_id"], name: "index_usages_on_song_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "church_id"
    t.boolean  "admin",                  default: false
    t.boolean  "church_admin",           default: false
    t.boolean  "church_leader",          default: false
  end

  add_index "users", ["church_id"], name: "index_users_on_church_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
