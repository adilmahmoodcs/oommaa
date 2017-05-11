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

ActiveRecord::Schema.define(version: 20170511132259) do

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

  create_table "assigned_domains", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_assigned_domains_on_domain_id", using: :btree
    t.index ["user_id"], name: "index_assigned_domains_on_user_id", using: :btree
  end

  create_table "brand_logos", force: :cascade do |t|
    t.integer  "brand_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "trademark_registration_number"
    t.string   "trademark_registration_location"
    t.string   "trademark_registration_category"
    t.string   "trademark_registration_url"
    t.index ["brand_id"], name: "index_brand_logos_on_brand_id", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "licensor_id"
    t.string   "nicknames",   default: [],              array: true
    t.index ["licensor_id"], name: "index_brands_on_licensor_id", using: :btree
    t.index ["nicknames"], name: "index_brands_on_nicknames", using: :gin
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "domains", force: :cascade do |t|
    t.string   "name",                    null: false
    t.integer  "status",      default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "owner_email"
  end

  create_table "facebook_page_brands", force: :cascade do |t|
    t.integer  "facebook_page_id"
    t.integer  "brand_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["brand_id"], name: "index_facebook_page_brands_on_brand_id", using: :btree
    t.index ["facebook_page_id"], name: "index_facebook_page_brands_on_facebook_page_id", using: :btree
  end

  create_table "facebook_pages", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "url",                                   null: false
    t.string   "image_url"
    t.string   "facebook_id",                           null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "old_brand_ids",            default: [],              array: true
    t.datetime "shut_down_by_facebook_at"
    t.integer  "cached_licensor_ids",      default: [],              array: true
    t.integer  "status",                   default: 0
    t.string   "affiliate_name"
    t.index ["cached_licensor_ids"], name: "index_facebook_pages_on_cached_licensor_ids", using: :gin
    t.index ["old_brand_ids"], name: "index_facebook_pages_on_old_brand_ids", using: :gin
  end

  create_table "facebook_posts", force: :cascade do |t|
    t.string   "facebook_id",                           null: false
    t.string   "message",                               null: false
    t.datetime "published_at"
    t.string   "permalink"
    t.string   "image_url"
    t.integer  "status",                   default: 0,  null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "facebook_page_id"
    t.string   "link"
    t.string   "all_links",                default: [],              array: true
    t.datetime "whitelisted_at"
    t.string   "whitelisted_by"
    t.datetime "blacklisted_at"
    t.string   "blacklisted_by"
    t.datetime "reported_to_facebook_at"
    t.string   "reported_to_facebook_by"
    t.datetime "shut_down_by_facebook_at"
    t.string   "all_domains",              default: [],              array: true
    t.string   "added_by"
    t.string   "facebook_report_number"
    t.integer  "likes"
    t.integer  "mass_job_status",          default: 0
    t.datetime "greylisted_at"
    t.string   "greylisted_by"
    t.datetime "shutdown_queue_at"
    t.string   "shutdown_queue_by"
    t.index ["all_domains"], name: "index_facebook_posts_on_all_domains", using: :gin
    t.index ["all_links"], name: "index_facebook_posts_on_all_links", using: :gin
    t.index ["facebook_page_id"], name: "index_facebook_posts_on_facebook_page_id", using: :btree
    t.index ["status", "published_at"], name: "index_facebook_posts_on_status_and_published_at", using: :btree
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "licensors", force: :cascade do |t|
    t.string   "name",                      null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "main_contact"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "cease_and_desist_template"
    t.string   "cease_and_desist_subject"
  end

  create_table "post_brands", force: :cascade do |t|
    t.integer  "facebook_post_id"
    t.integer  "brand_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["brand_id"], name: "index_post_brands_on_brand_id", using: :btree
    t.index ["facebook_post_id"], name: "index_post_brands_on_facebook_post_id", using: :btree
  end

  create_table "screenshots", force: :cascade do |t|
    t.integer  "facebook_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "type"
    t.index ["facebook_post_id"], name: "index_screenshots_on_facebook_post_id", using: :btree
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
    t.integer  "role",                   default: 0,  null: false
    t.integer  "licensor_id"
    t.string   "name"
    t.string   "widgets",                default: [],              array: true
    t.string   "primary_color"
    t.string   "secondary_color"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["licensor_id"], name: "index_users_on_licensor_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["widgets"], name: "index_users_on_widgets", using: :gin
  end

  add_foreign_key "brand_logos", "brands"
  add_foreign_key "brands", "licensors"
  add_foreign_key "facebook_page_brands", "brands"
  add_foreign_key "facebook_page_brands", "facebook_pages"
  add_foreign_key "facebook_posts", "facebook_pages"
  add_foreign_key "screenshots", "facebook_posts"
  add_foreign_key "users", "licensors"
end
