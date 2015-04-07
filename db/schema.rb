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

ActiveRecord::Schema.define(version: 20150407170126) do

  create_table "adverts", force: true do |t|
    t.string   "address"
    t.integer  "advert_type"
    t.decimal  "area",                    precision: 8, scale: 2
    t.decimal  "price",                   precision: 8, scale: 2
    t.decimal  "height",                  precision: 8, scale: 2
    t.float    "longitude",    limit: 24
    t.float    "latitude",     limit: 24
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "validated",                                       default: false
    t.boolean  "activated",                                       default: false
    t.boolean  "light",                                           default: false
    t.boolean  "concierge",                                       default: false
    t.boolean  "car_access",                                      default: false
    t.boolean  "elevator",                                        default: false
    t.integer  "access_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "security"
    t.integer  "preservation"
    t.integer  "floor"
  end

  create_table "evaluations", force: true do |t|
    t.integer  "user_id"
    t.integer  "advert_id"
    t.integer  "score"
    t.text     "comment"
    t.boolean  "validated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: true do |t|
    t.integer  "advert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "reservations", force: true do |t|
    t.integer  "user_id"
    t.integer  "advert_id"
    t.boolean  "validated",  default: false
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "accept_cgu",             default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
