# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_29_142124) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bids", force: :cascade do |t|
    t.integer "user_id"
    t.integer "rfp_id"
    t.integer "amount"
    t.string "name"
    t.string "status"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id"
    t.string "customer_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "license_number"
    t.boolean "accept_provider_terms"
    t.text "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "new"
    t.date "applied_at"
    t.string "do_you_have_license"
    t.string "years_in_business"
    t.string "number_trucks_and_crew"
    t.string "regions_served"
    t.string "general_liablity_insurance"
    t.string "cargo_insurance"
    t.string "commercial_vehichle_insurance"
    t.string "usdot_mc_numbers"
    t.string "services"
    t.string "written_estimates"
    t.string "damage_claims"
    t.string "yelp_reviews"
    t.string "google_reviews"
    t.string "bbb_profile"
    t.string "employee_types"
    t.string "employee_background_checks"
    t.string "employee_uniforms"
    t.string "typical_response_time"
    t.string "guarantee_arrival_windows"
    t.string "billing_style"
    t.string "willing_to_sign_agreement"
    t.integer "current_step", default: 0
    t.index ["status"], name: "index_providers_on_status"
  end

  create_table "rfps", force: :cascade do |t|
    t.date "move_date"
    t.string "type"
    t.string "move_type"
    t.string "load_address"
    t.string "unload_address"
    t.integer "number_of_movers_requested"
    t.string "estimated_time_in_hours"
    t.string "loading_stairs"
    t.integer "loading_floor"
    t.string "loading_stairs_details"
    t.string "unloading_stairs"
    t.integer "unloading_floor"
    t.string "specialty_items_details"
    t.string "need_assistance_with_moving_supplies"
    t.string "donation_junk_removal"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "earliest_move_date"
    t.date "move_finish_date"
    t.string "has_specialty_items"
    t.string "loading_elevator"
    t.string "unloading_elevator"
    t.text "unloading_stairs_details"
    t.integer "user_id"
    t.integer "current_step", default: 0
    t.string "status", default: "new"
    t.string "what_are_you_hauling"
    t.text "hauling_notes"
    t.integer "hauling_distance_in_miles"
    t.index ["status"], name: "index_rfps_on_status"
  end

  create_table "rfps_specialty_items", id: false, force: :cascade do |t|
    t.integer "rfp_id", null: false
    t.integer "specialty_item_id", null: false
    t.index ["rfp_id", "specialty_item_id"], name: "index_rfps_specialty_items_on_rfp_id_and_specialty_item_id"
    t.index ["specialty_item_id", "rfp_id"], name: "index_rfps_specialty_items_on_specialty_item_id_and_rfp_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "specialty_items", force: :cascade do |t|
    t.integer "rfp_id"
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "timezone", default: "UTC"
    t.string "phone"
    t.boolean "allow_text_messages"
    t.boolean "terms_accepted"
    t.datetime "terms_accepted_at"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end
