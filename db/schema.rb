# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_27_175600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "post_id"
    t.integer "parent_id"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "created_by"
    t.integer "topic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "alias"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alias"], name: "index_topics_on_alias", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"

  create_table "artist_membership_applications", force: :cascade do |t|
    t.string "applicant_email", null: false
    t.string "display_name", null: false
    t.string "status", default: "draft", null: false
    t.boolean "education_verified", default: false, null: false
    t.text "statement"
    t.text "moderator_summary"
    t.datetime "submitted_at"
    t.datetime "decided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_email"], name: "index_artist_membership_applications_on_applicant_email"
    t.index ["status"], name: "index_artist_membership_applications_on_status"
  end

  create_table "artist_portfolio_works", force: :cascade do |t|
    t.bigint "artist_membership_application_id", null: false
    t.string "category", null: false
    t.string "title", null: false
    t.string "technique"
    t.integer "year_created"
    t.text "author_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_membership_application_id", "category"], name: "index_artist_portfolio_works_on_application_and_category"
  end

  create_table "artist_reviews", force: :cascade do |t|
    t.bigint "artist_membership_application_id", null: false
    t.string "reviewer_name", null: false
    t.string "category", null: false
    t.integer "score", null: false
    t.text "comment", null: false
    t.boolean "visible_to_applicant", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_membership_application_id", "category"], name: "index_artist_reviews_on_application_and_category"
  end

  add_foreign_key "artist_portfolio_works", "artist_membership_applications"
  add_foreign_key "artist_reviews", "artist_membership_applications"

end
