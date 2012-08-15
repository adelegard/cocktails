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

ActiveRecord::Schema.define(:version => 20120814012350) do

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uuid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "ingredient_photos", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "ingredient_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "ingredient_photos", ["ingredient_id"], :name => "index_ingredient_photos_on_ingredient_id"
  add_index "ingredient_photos", ["user_id"], :name => "index_ingredient_photos_on_user_id"

  create_table "ingredients", :force => true do |t|
    t.string   "ingredient"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "delta",      :default => true, :null => false
  end

  create_table "liquor_cabinets", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "ingredient_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "recipe_ingredients", :id => false, :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.integer  "order"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "amount"
  end

  create_table "recipe_photos", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "recipe_photos", ["recipe_id"], :name => "index_recipe_photos_on_recipe_id"
  add_index "recipe_photos", ["user_id"], :name => "index_recipe_photos_on_user_id"

  create_table "recipe_users", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.boolean  "starred"
    t.decimal  "rating",     :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "liked"
  end

  create_table "recipes", :force => true do |t|
    t.string   "title"
    t.text     "directions"
    t.string   "glass"
    t.string   "alcohol"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.decimal  "rating_avg",         :precision => 10, :scale => 0
    t.integer  "rating_count"
    t.integer  "created_by_user_id"
    t.boolean  "delta",                                             :default => true, :null => false
    t.integer  "view_count"
    t.integer  "servings"
    t.text     "inspiration"
    t.integer  "shared"
  end

  create_table "user_follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follow_user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "nickname"
    t.string   "name"
    t.string   "url"
    t.string   "location"
    t.text     "about_me"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
