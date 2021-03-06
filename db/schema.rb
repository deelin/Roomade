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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120511045317) do

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apartment_amenities", :force => true do |t|
    t.integer  "apartment_id"
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apartment_photos", :force => true do |t|
    t.integer  "apartment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "apartments", :force => true do |t|
    t.string   "address"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.float    "dist_to_campus"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.boolean  "recommendation"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "apartment_id"
    t.float    "rent"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "roommates"
    t.integer  "space"
    t.integer  "noise"
    t.boolean  "security"
    t.integer  "management"
    t.integer  "condition"
    t.boolean  "recommendation"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "security_level"
    t.integer  "rating"
  end

  create_table "user_apartment_queues", :force => true do |t|
    t.integer  "user_id"
    t.integer  "apartment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
