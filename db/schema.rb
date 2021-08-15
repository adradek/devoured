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

ActiveRecord::Schema.define(version: 20210815172827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "title",                       null: false
    t.string   "author"
    t.boolean  "short",       default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "compilation", default: false
    t.index ["title", "author"], name: "index_books_on_title_and_author", unique: true, using: :btree
  end

  create_table "films", force: :cascade do |t|
    t.string   "name_rus"
    t.string   "name_eng"
    t.boolean  "seria",        default: false, null: false
    t.integer  "imdb"
    t.string   "tomatoes"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "tomatoes_top"
    t.integer  "tomatoes_all"
  end

  create_table "intents", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "intended_type"
    t.integer  "intended_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["intended_type", "intended_id"], name: "index_intents_on_intended_type_and_intended_id", using: :btree
    t.index ["user_id"], name: "index_intents_on_user_id", using: :btree
  end

  create_table "readings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.date     "start"
    t.date     "finish"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "professional",           default: false, null: false
    t.boolean  "significant",            default: false
    t.boolean  "compilation",            default: false
    t.integer  "compilation_reading_id"
    t.index ["book_id"], name: "index_readings_on_book_id", using: :btree
    t.index ["compilation_reading_id"], name: "index_readings_on_compilation_reading_id", using: :btree
    t.index ["user_id"], name: "index_readings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "watchings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "film_id"
    t.date     "start"
    t.date     "finish"
    t.string   "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_watchings_on_film_id", using: :btree
    t.index ["user_id"], name: "index_watchings_on_user_id", using: :btree
  end

  add_foreign_key "intents", "users"
  add_foreign_key "readings", "books"
  add_foreign_key "readings", "users"
  add_foreign_key "watchings", "films"
  add_foreign_key "watchings", "users"
end
