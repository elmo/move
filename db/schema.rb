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

ActiveRecord::Schema[8.0].define(version: 2025_07_04_140443) do
  create_table "account_users", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "user_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "gifted", default: false
    t.string "processor_customer_id"
    t.integer "subscription_status", default: 0
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

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

  create_table "agreements", force: :cascade do |t|
    t.integer "user_id"
    t.integer "provider_id"
    t.string "provider_company_name"
    t.string "provider_company_signature"
    t.datetime "provider_company_signed_date"
    t.string "provider_user_name"
    t.string "provider_user_signature"
    t.datetime "provider_user_signed_date"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "agree_to_platform_terms"
    t.integer "provider_id"
    t.text "notes"
    t.index ["provider_id"], name: "index_bids_on_provider_id"
  end

  create_table "commerce_benefits", force: :cascade do |t|
    t.string "name"
    t.text "benefit_text"
    t.text "tooltip"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commerce_payment_methods", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "processor_customer_id"
    t.string "processor_payment_method_id"
    t.integer "brand"
    t.string "last4"
    t.integer "expiration_month"
    t.integer "expiration_year"
    t.boolean "default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_commerce_payment_methods_on_account_id"
  end

  create_table "commerce_payments", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "currency"
    t.integer "payment_method_id"
    t.integer "subscription_id"
    t.integer "purchase_id"
    t.string "processor_payment_id"
    t.string "processor_customer_id"
    t.string "processor_invoice_id"
    t.integer "amount"
    t.integer "status", default: 0
    t.string "resolve_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_commerce_payments_on_account_id"
    t.index ["payment_method_id"], name: "index_commerce_payments_on_payment_method_id"
    t.index ["purchase_id"], name: "index_commerce_payments_on_purchase_id"
    t.index ["subscription_id"], name: "index_commerce_payments_on_subscription_id"
  end

  create_table "commerce_plan_benefits", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "benefit_id", null: false
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_commerce_plan_benefits_on_benefit_id"
    t.index ["plan_id"], name: "index_commerce_plan_benefits_on_plan_id"
  end

  create_table "commerce_plans", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.integer "price_a_id"
    t.string "price_a_alt_amount"
    t.string "price_a_append_text"
    t.string "price_a_note"
    t.integer "price_b_id"
    t.string "price_b_alt_amount"
    t.string "price_b_append_text"
    t.string "price_b_note"
    t.integer "position", default: 1
    t.string "highlight_text"
    t.boolean "active", default: true
    t.text "short_description"
    t.text "benefits_note"
    t.string "button_purchase_label"
    t.string "button_change_to_plan_label"
    t.string "button_current_label"
    t.string "button_support_text"
    t.string "button_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_a_id"], name: "index_commerce_plans_on_price_a_id"
    t.index ["price_b_id"], name: "index_commerce_plans_on_price_b_id"
  end

  create_table "commerce_prices", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "name"
    t.string "slug"
    t.string "processor_price_id"
    t.integer "amount"
    t.boolean "recurring", default: false
    t.integer "recurring_interval", default: 0
    t.integer "trial_days", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_commerce_prices_on_product_id"
  end

  create_table "commerce_products", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "processor_product_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commerce_purchases", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "product_id", null: false
    t.integer "price_id", null: false
    t.integer "payment_method_id"
    t.string "processor_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "first_payment_id"
    t.index ["account_id"], name: "index_commerce_purchases_on_account_id"
    t.index ["first_payment_id"], name: "index_commerce_purchases_on_first_payment_id"
    t.index ["payment_method_id"], name: "index_commerce_purchases_on_payment_method_id"
    t.index ["price_id"], name: "index_commerce_purchases_on_price_id"
    t.index ["product_id"], name: "index_commerce_purchases_on_product_id"
  end

  create_table "commerce_subscriptions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "product_id", null: false
    t.integer "purchase_id", null: false
    t.integer "price_id", null: false
    t.integer "payment_method_id"
    t.string "processor_customer_id"
    t.string "processor_subscription_id"
    t.integer "status", default: 0
    t.datetime "current_period_end"
    t.datetime "cancellation_date"
    t.text "cancellation_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_commerce_subscriptions_on_account_id"
    t.index ["payment_method_id"], name: "index_commerce_subscriptions_on_payment_method_id"
    t.index ["price_id"], name: "index_commerce_subscriptions_on_price_id"
    t.index ["product_id"], name: "index_commerce_subscriptions_on_product_id"
    t.index ["purchase_id"], name: "index_commerce_subscriptions_on_purchase_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id"
    t.string "customer_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "created_by_user_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["created_by_user_id"], name: "index_invitations_on_created_by_user_id"
  end

  create_table "loading_stairs", force: :cascade do |t|
    t.string "name"
  end

  create_table "loading_stairs_rfps", id: false, force: :cascade do |t|
    t.integer "rfp_id", null: false
    t.integer "loading_stair_id", null: false
    t.index ["loading_stair_id", "rfp_id"], name: "index_loading_stairs_rfps_on_loading_stair_id_and_rfp_id"
    t.index ["rfp_id", "loading_stair_id"], name: "index_loading_stairs_rfps_on_rfp_id_and_loading_stair_id"
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
    t.integer "loading_floor"
    t.string "loading_stairs_details"
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

  create_table "rfps_unloading_stairs", id: false, force: :cascade do |t|
    t.integer "rfp_id", null: false
    t.integer "unloading_stair_id", null: false
    t.index ["rfp_id", "unloading_stair_id"], name: "index_rfps_unloading_stairs_on_rfp_id_and_unloading_stair_id"
    t.index ["unloading_stair_id", "rfp_id"], name: "index_rfps_unloading_stairs_on_unloading_stair_id_and_rfp_id"
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

  create_table "unloading_stairs", force: :cascade do |t|
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
    t.boolean "admin", default: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "commerce_payment_methods", "accounts"
  add_foreign_key "commerce_payments", "accounts"
  add_foreign_key "commerce_payments", "commerce_payment_methods", column: "payment_method_id"
  add_foreign_key "commerce_payments", "commerce_purchases", column: "purchase_id"
  add_foreign_key "commerce_payments", "commerce_subscriptions", column: "subscription_id"
  add_foreign_key "commerce_plan_benefits", "commerce_benefits", column: "benefit_id"
  add_foreign_key "commerce_plan_benefits", "commerce_plans", column: "plan_id"
  add_foreign_key "commerce_plans", "commerce_prices", column: "price_a_id"
  add_foreign_key "commerce_plans", "commerce_prices", column: "price_b_id"
  add_foreign_key "commerce_prices", "commerce_products", column: "product_id"
  add_foreign_key "commerce_purchases", "accounts"
  add_foreign_key "commerce_purchases", "commerce_payment_methods", column: "payment_method_id"
  add_foreign_key "commerce_purchases", "commerce_payments", column: "first_payment_id"
  add_foreign_key "commerce_purchases", "commerce_prices", column: "price_id"
  add_foreign_key "commerce_purchases", "commerce_products", column: "product_id"
  add_foreign_key "commerce_subscriptions", "accounts"
  add_foreign_key "commerce_subscriptions", "commerce_payment_methods", column: "payment_method_id"
  add_foreign_key "commerce_subscriptions", "commerce_prices", column: "price_id"
  add_foreign_key "commerce_subscriptions", "commerce_products", column: "product_id"
  add_foreign_key "commerce_subscriptions", "commerce_purchases", column: "purchase_id"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "invitations", "users", column: "created_by_user_id"
  add_foreign_key "sessions", "users"
end
