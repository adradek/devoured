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

ActiveRecord::Schema.define(version: 2023_11_18_211846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "author"
    t.boolean "short", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "compilation", default: false
    t.index ["title", "author"], name: "index_books_on_title_and_author", unique: true
  end

  create_table "films", id: :serial, force: :cascade do |t|
    t.string "name_rus"
    t.string "name_eng"
    t.boolean "seria", default: false, null: false
    t.integer "imdb"
    t.string "tomatoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tomatoes_top"
    t.integer "tomatoes_all"
  end

  create_table "intents", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "intended_type"
    t.integer "intended_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intended_type", "intended_id"], name: "index_intents_on_intended_type_and_intended_id"
    t.index ["user_id"], name: "index_intents_on_user_id"
  end

  create_table "readings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.date "start"
    t.date "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "professional", default: false, null: false
    t.boolean "significant", default: false
    t.boolean "compilation", default: false
    t.integer "compilation_reading_id"
    t.index ["book_id"], name: "index_readings_on_book_id"
    t.index ["compilation_reading_id"], name: "index_readings_on_compilation_reading_id"
    t.index ["user_id"], name: "index_readings_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["secret_id"], name: "index_users_on_secret_id", unique: true
  end

  create_table "watchings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "film_id"
    t.date "start"
    t.date "finish"
    t.string "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_watchings_on_film_id"
    t.index ["user_id"], name: "index_watchings_on_user_id"
  end

  add_foreign_key "intents", "users"
  add_foreign_key "readings", "books"
  add_foreign_key "readings", "users"
  add_foreign_key "watchings", "films"
  add_foreign_key "watchings", "users"
end
