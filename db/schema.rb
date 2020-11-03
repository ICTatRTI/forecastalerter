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

ActiveRecord::Schema.define(version: 2020_11_03_173348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", id: :serial, force: :cascade do |t|
    t.string "usaid_web_id"
    t.text "mbio_name"
    t.text "aa_specialist"
    t.text "title"
    t.text "description"
    t.text "sector"
    t.string "code"
    t.string "cost_range"
    t.text "incumbent"
    t.string "type"
    t.string "sb_setaside"
    t.string "fiscal_year"
    t.date "award_date"
    t.date "release_date"
    t.string "award_length"
    t.string "solicitation_number"
    t.text "bf_status_change"
    t.string "location"
    t.datetime "last_modified_at"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eligibility_criteria"
    t.string "category_management_contract_vehicle"
    t.string "cocreation"
    t.index ["usaid_web_id"], name: "index_awards_on_usaid_web_id", unique: true
  end

  create_table "grants_snapshots", id: :serial, force: :cascade do |t|
    t.datetime "snapshot_time"
    t.json "awards_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "grantsgov_web_file_name"
    t.string "grantsgov_web_content_type"
    t.integer "grantsgov_web_file_size"
    t.datetime "grantsgov_web_updated_at"
  end

  create_table "snapshots", id: :serial, force: :cascade do |t|
    t.datetime "snapshot_time"
    t.json "awards_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "forecast_workbook_file_name"
    t.string "forecast_workbook_content_type"
    t.integer "forecast_workbook_file_size"
    t.datetime "forecast_workbook_updated_at"
    t.string "forecast_web_file_name"
    t.string "forecast_web_content_type"
    t.integer "forecast_web_file_size"
    t.datetime "forecast_web_updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

end
