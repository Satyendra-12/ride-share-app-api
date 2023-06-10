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

ActiveRecord::Schema[7.0].define(version: 2023_05_19_090834) do
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

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "passenger_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["passenger_id"], name: "index_chats_on_passenger_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "passengers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "publish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.integer "seats"
    t.string "status"
    t.index ["publish_id"], name: "index_passengers_on_publish_id"
    t.index ["user_id"], name: "index_passengers_on_user_id"
  end

  create_table "publishes", force: :cascade do |t|
    t.string "source"
    t.string "destination"
    t.integer "passengers_count"
    t.string "add_city"
    t.date "date"
    t.time "time"
    t.float "set_price"
    t.text "about_ride"
    t.bigint "driver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "source_latitude"
    t.float "source_longitude"
    t.float "destination_latitude"
    t.float "destination_longitude"
    t.bigint "vehicle_id"
    t.string "book_instantly"
    t.string "mid_seat"
    t.json "select_route"
    t.string "status"
    t.index ["driver_id"], name: "index_publishes_on_driver_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating"
    t.integer "rideid", null: false
    t.text "comment"
    t.integer "giver", null: false
    t.integer "receiver", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.string "title"
    t.string "phone_number"
    t.text "bio"
    t.string "travel_preferences"
    t.text "postal_address"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "activate_token"
    t.string "session_key"
    t.float "average_rating", default: 0.0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "country"
    t.string "vehicle_number"
    t.string "vehicle_brand"
    t.string "vehicle_name"
    t.string "vehicle_type"
    t.string "vehicle_color"
    t.integer "vehicle_model_year"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "passengers"
  add_foreign_key "chats", "users"
  add_foreign_key "passengers", "publishes", on_delete: :cascade
  add_foreign_key "passengers", "users", on_delete: :cascade
  add_foreign_key "publishes", "users", column: "driver_id", on_delete: :cascade
  add_foreign_key "publishes", "vehicles", on_delete: :cascade
  add_foreign_key "ratings", "publishes", column: "rideid", on_delete: :cascade
  add_foreign_key "ratings", "users", column: "giver", on_delete: :cascade
  add_foreign_key "ratings", "users", column: "receiver", on_delete: :cascade
  add_foreign_key "vehicles", "users", on_delete: :cascade
end
