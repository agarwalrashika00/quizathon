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

ActiveRecord::Schema[7.0].define(version: 2023_06_08_100949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "published", default: true
    t.bigint "parent_comment_id"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title"
    t.string "description"
    t.bigint "super_genre_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["super_genre_id"], name: "index_genres_on_super_genre_id"
  end

  create_table "genres_quizzes", id: false, force: :cascade do |t|
    t.bigint "genre_id", null: false
    t.bigint "quiz_id", null: false
    t.index ["genre_id", "quiz_id"], name: "index_genres_quizzes_on_genre_id_and_quiz_id"
    t.index ["quiz_id", "genre_id"], name: "index_genres_quizzes_on_quiz_id_and_genre_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.bigint "question_id"
    t.string "type"
    t.string "data"
    t.boolean "correct"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "description"
    t.boolean "active", default: true
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_orders", force: :cascade do |t|
    t.string "session_id"
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_orders_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_orders_on_user_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.bigint "quiz_id"
    t.bigint "question_id"
    t.boolean "active", default: true
    t.index ["question_id", "quiz_id"], name: "index_quiz_questions_on_question_id_and_quiz_id"
    t.index ["question_id"], name: "index_quiz_questions_on_question_id"
    t.index ["quiz_id", "question_id"], name: "index_quiz_questions_on_quiz_id_and_question_id"
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quiz_runners", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "quiz_id"
    t.integer "status"
    t.integer "score"
    t.string "questions_sorting_order"
    t.integer "current_question_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_runners_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_runners_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "description"
    t.integer "time_limit_in_seconds"
    t.integer "level"
    t.boolean "active", default: false
    t.datetime "featured_at", precision: nil
    t.bigint "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_ratings_on_quiz_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "user_solutions", force: :cascade do |t|
    t.bigint "quiz_question_id"
    t.bigint "user_id"
    t.bigint "marked_option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marked_option_id"], name: "index_user_solutions_on_marked_option_id"
    t.index ["quiz_question_id"], name: "index_user_solutions_on_quiz_question_id"
    t.index ["user_id"], name: "index_user_solutions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.boolean "blocked", default: false
    t.jsonb "notification_preferences", default: {"email"=>true, "in_app"=>true}
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "genres", "genres", column: "super_genre_id"
  add_foreign_key "question_options", "questions"
  add_foreign_key "quiz_questions", "questions"
  add_foreign_key "quiz_questions", "quizzes"
  add_foreign_key "quizzes", "users", column: "created_by"
end
