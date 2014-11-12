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

ActiveRecord::Schema.define(version: 20141009093718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "kendocup_clubs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kendocup_cups", force: true do |t|
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "junior_fees_chf"
    t.integer  "junior_fees_eur"
    t.integer  "adult_fees_chf"
    t.integer  "adult_fees_eur"
  end

  create_table "kendocup_events", force: true do |t|
    t.integer  "cup_id"
    t.string   "name_en"
    t.string   "name_fr"
    t.datetime "start_on"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_events", ["cup_id"], name: "index_kendocup_events_on_cup_id", using: :btree

  create_table "kendocup_fights", force: true do |t|
    t.integer  "individual_category_id"
    t.integer  "team_category_id"
    t.integer  "winner_id"
    t.integer  "parent_fight_1_id"
    t.integer  "parent_fight_2_id"
    t.string   "fighter_type"
    t.integer  "fighter_1_id"
    t.integer  "fighter_2_id"
    t.integer  "number"
    t.string   "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_fights", ["fighter_1_id"], name: "index_kendocup_fights_on_fighter_1_id", using: :btree
  add_index "kendocup_fights", ["fighter_2_id"], name: "index_kendocup_fights_on_fighter_2_id", using: :btree
  add_index "kendocup_fights", ["individual_category_id"], name: "index_kendocup_fights_on_individual_category_id", using: :btree
  add_index "kendocup_fights", ["number"], name: "index_kendocup_fights_on_number", using: :btree
  add_index "kendocup_fights", ["parent_fight_1_id"], name: "index_kendocup_fights_on_parent_fight_1_id", using: :btree
  add_index "kendocup_fights", ["parent_fight_2_id"], name: "index_kendocup_fights_on_parent_fight_2_id", using: :btree
  add_index "kendocup_fights", ["team_category_id"], name: "index_kendocup_fights_on_team_category_id", using: :btree
  add_index "kendocup_fights", ["winner_id"], name: "index_kendocup_fights_on_winner_id", using: :btree

  create_table "kendocup_headlines", force: true do |t|
    t.string   "title_fr"
    t.string   "title_en"
    t.text     "content_fr"
    t.text     "content_en"
    t.integer  "cup_id"
    t.boolean  "shown",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_headlines", ["cup_id"], name: "index_kendocup_headlines_on_cup_id", using: :btree

  create_table "kendocup_individual_categories", force: true do |t|
    t.string   "name"
    t.integer  "pool_size"
    t.integer  "out_of_pool"
    t.integer  "min_age"
    t.integer  "max_age"
    t.text     "description_en"
    t.text     "description_fr"
    t.integer  "cup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_individual_categories", ["cup_id"], name: "index_kendocup_individual_categories_on_cup_id", using: :btree

  create_table "kendocup_kenshis", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "female"
    t.integer  "cup_id"
    t.integer  "user_id"
    t.date     "dob"
    t.integer  "club_id"
    t.string   "email"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_kenshis", ["club_id"], name: "index_kendocup_kenshis_on_club_id", using: :btree
  add_index "kendocup_kenshis", ["cup_id"], name: "index_kendocup_kenshis_on_cup_id", using: :btree
  add_index "kendocup_kenshis", ["grade"], name: "index_kendocup_kenshis_on_grade", using: :btree
  add_index "kendocup_kenshis", ["last_name"], name: "index_kendocup_kenshis_on_last_name", using: :btree
  add_index "kendocup_kenshis", ["user_id"], name: "index_kendocup_kenshis_on_user_id", using: :btree

  create_table "kendocup_participations", force: true do |t|
    t.integer  "category_id"
    t.string   "category_type"
    t.integer  "team_id"
    t.integer  "kenshi_id"
    t.integer  "pool_number"
    t.integer  "pool_position"
    t.boolean  "ronin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_participations", ["category_id", "category_type"], name: "index_kendocup_participations_on_category_id_and_category_type", using: :btree
  add_index "kendocup_participations", ["kenshi_id"], name: "index_kendocup_participations_on_kenshi_id", using: :btree
  add_index "kendocup_participations", ["pool_number"], name: "index_kendocup_participations_on_pool_number", using: :btree
  add_index "kendocup_participations", ["team_id"], name: "index_kendocup_participations_on_team_id", using: :btree

  create_table "kendocup_products", force: true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.text     "description_en"
    t.text     "description_fr"
    t.integer  "fee_chf"
    t.integer  "fee_eu"
    t.integer  "event_id"
    t.integer  "cup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kendocup_purchases", force: true do |t|
    t.integer  "kenshi_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_purchases", ["kenshi_id"], name: "index_kendocup_purchases_on_kenshi_id", using: :btree
  add_index "kendocup_purchases", ["product_id"], name: "index_kendocup_purchases_on_product_id", using: :btree

  create_table "kendocup_results", force: true do |t|
    t.string   "name"
    t.string   "category_type"
    t.integer  "category_id"
    t.integer  "kenshi_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_results", ["kenshi_id"], name: "index_kendocup_results_on_kenshi_id", using: :btree

  create_table "kendocup_team_categories", force: true do |t|
    t.string   "name"
    t.integer  "pool_size"
    t.integer  "out_of_pool"
    t.integer  "min_age"
    t.integer  "max_age"
    t.text     "description_en"
    t.text     "description_fr"
    t.integer  "cup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_team_categories", ["cup_id"], name: "index_kendocup_team_categories_on_cup_id", using: :btree

  create_table "kendocup_teams", force: true do |t|
    t.string   "name"
    t.integer  "team_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kendocup_teams", ["team_category_id"], name: "index_kendocup_teams_on_team_category_id", using: :btree

  create_table "kendocup_users", force: true do |t|
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
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "female"
    t.date     "dob"
    t.integer  "club_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "kendocup_users", ["email"], name: "index_kendocup_users_on_email", unique: true, using: :btree
  add_index "kendocup_users", ["reset_password_token"], name: "index_kendocup_users_on_reset_password_token", unique: true, using: :btree

end