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

ActiveRecord::Schema[7.2].define(version: 2024_12_15_134658) do
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

  create_table "donhangs", force: :cascade do |t|
    t.string "hoten"
    t.string "sdt"
    t.string "email"
    t.text "diachi"
    t.string "trangthaithanhtoan"
    t.integer "tongthanhtoan"
    t.datetime "ngaydathang"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trangthai"
    t.string "thongtinsanpham"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "taikhoan_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipient_id", null: false
    t.boolean "read", default: false
    t.string "image"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["taikhoan_id"], name: "index_messages_on_taikhoan_id"
  end

  create_table "sanphams", force: :cascade do |t|
    t.string "ten", null: false
    t.string "loai"
    t.text "mota"
    t.decimal "gia", precision: 10, scale: 2
    t.integer "soluong"
    t.string "hinhanh"
    t.string "donvi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "gianhap"
  end

  create_table "taikhoans", force: :cascade do |t|
    t.string "username"
    t.string "pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "hoten"
    t.date "ngaysinh"
    t.string "diachi"
    t.string "sdt"
    t.string "quyen"
    t.string "avatar_url"
    t.text "giohang"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "taikhoans"
  add_foreign_key "messages", "taikhoans", column: "recipient_id"
end
