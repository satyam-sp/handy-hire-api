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

ActiveRecord::Schema[7.1].define(version: 2025_07_14_094446) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "address_line_1", null: false
    t.string "address_line_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "address_type", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email"
    t.string "password_digest", null: false
    t.string "full_name", null: false
    t.date "date_of_birth"
    t.string "gender"
    t.string "mobile_number", null: false
    t.string "aadhaar_number"
    t.boolean "aadhaar_verified", default: false
    t.string "pan_number"
    t.text "address"
    t.text "current_address"
    t.boolean "same_as_permanent_address"
    t.integer "experience_years"
    t.string "work_location"
    t.string "availability", default: "parttime"
    t.decimal "expected_pay", precision: 10, scale: 2
    t.boolean "verified", default: false
    t.jsonb "job_category_ids", default: []
    t.jsonb "languages_spoken", default: []
    t.jsonb "references_list", default: []
    t.jsonb "work_photos", default: []
    t.jsonb "additional_info", default: {}
    t.boolean "police_verified", default: false
    t.decimal "rating", precision: 3, scale: 2, default: "0.0"
    t.integer "reviews_count", default: 0
    t.integer "registration_step", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aadhaar_number"], name: "index_employees_on_aadhaar_number", unique: true
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["mobile_number"], name: "index_employees_on_mobile_number", unique: true
  end

  create_table "instant_job_applications", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "instant_job_id", null: false
    t.decimal "final_price"
    t.integer "status", default: 0, null: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_instant_job_applications_on_employee_id"
    t.index ["instant_job_id"], name: "index_instant_job_applications_on_instant_job_id"
  end

  create_table "instant_jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "zipcode"
    t.string "state"
    t.string "country", default: "india"
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "job_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.integer "rate_type", default: 0, null: false
    t.date "slot_date"
    t.string "slot_time"
    t.index ["job_category_id"], name: "index_instant_jobs_on_job_category_id"
    t.index ["latitude", "longitude"], name: "index_instant_jobs_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_instant_jobs_on_user_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.string "status", default: "pending", null: false
    t.text "cover_letter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_job_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_job_categories_on_parent_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_category_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "location", null: false
    t.decimal "expected_pay", precision: 10, scale: 2, null: false
    t.string "pay_type", default: "fixed", null: false
    t.string "payment_mode"
    t.date "start_date", null: false
    t.date "end_date"
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_category_id"], name: "index_jobs_on_job_category_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "user_id", null: false
    t.bigint "employee_id", null: false
    t.integer "rating", null: false
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymous", default: false
    t.index ["employee_id"], name: "index_reviews_on_employee_id"
    t.index ["job_id"], name: "index_reviews_on_job_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "mobile_number", null: false
    t.string "profile_photo"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp_secret"
    t.datetime "otp_sent_at"
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "instant_job_applications", "employees"
  add_foreign_key "instant_job_applications", "instant_jobs"
  add_foreign_key "instant_jobs", "job_categories"
  add_foreign_key "instant_jobs", "users"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "job_categories", "job_categories", column: "parent_id"
  add_foreign_key "jobs", "job_categories"
  add_foreign_key "jobs", "users"
  add_foreign_key "reviews", "jobs"
end
