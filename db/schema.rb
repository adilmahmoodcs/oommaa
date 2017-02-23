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

ActiveRecord::Schema.define(version: 20170223091039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name",              null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "licensor_id"
    t.index ["licensor_id"], name: "index_brands_on_licensor_id", using: :btree
  end

  create_table "domains", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "facebook_pages", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "url",                      null: false
    t.string   "image_url"
    t.string   "facebook_id",              null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "brand_ids",   default: [],              array: true
    t.index ["brand_ids"], name: "index_facebook_pages_on_brand_ids", using: :gin
  end

  create_table "facebook_posts", force: :cascade do |t|
    t.string   "facebook_id",                    null: false
    t.string   "message",                        null: false
    t.datetime "published_at"
    t.string   "permalink"
    t.string   "image_url"
    t.integer  "status",            default: 0,  null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "facebook_page_id"
    t.datetime "status_changed_at"
    t.string   "link"
    t.string   "all_links",         default: [],              array: true
    t.datetime "whitelisted_at"
    t.string   "whitelisted_by"
    t.datetime "blacklisted_at"
    t.string   "blacklisted_by"
    t.index ["all_links"], name: "index_facebook_posts_on_all_links", using: :gin
    t.index ["facebook_page_id"], name: "index_facebook_posts_on_facebook_page_id", using: :btree
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "licensors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "brands", "licensors"
  add_foreign_key "facebook_posts", "facebook_pages"
end
