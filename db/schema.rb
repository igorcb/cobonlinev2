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

ActiveRecord::Schema[7.0].define(version: 2023_02_06_200124) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advances", force: :cascade do |t|
    t.bigint "client_id"
    t.date "date_advance", null: false
    t.decimal "price", precision: 9, scale: 2, null: false
    t.decimal "percent", precision: 9, scale: 2, null: false
    t.integer "number_parts", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["client_id"], name: "index_advances_on_client_id"
    t.index ["date_advance"], name: "index_advances_on_date_advance"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "geral", default: false
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "city_id"
    t.string "name", limit: 100, null: false
    t.string "fone", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "home_district"
    t.string "rg", limit: 30
    t.string "cpf", limit: 30
    t.date "birthday"
    t.decimal "credit_limit", precision: 9, scale: 2, default: "0.0", null: false
    t.string "indication", limit: 100
    t.integer "status", default: 0
    t.string "home_address", limit: 100
    t.string "home_number", limit: 100
    t.string "home_complement", limit: 100
    t.string "home_city", limit: 100
    t.string "home_state", limit: 100
    t.string "home_zip", limit: 100
    t.string "billing_address", limit: 100
    t.string "billing_number", limit: 100
    t.string "billing_complement", limit: 100
    t.string "billing_district", limit: 100
    t.string "billing_city", limit: 100
    t.string "billing_state", limit: 100
    t.string "billing_zip", limit: 100
    t.index ["city_id"], name: "index_clients_on_city_id"
  end

  create_table "costs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_accounts", force: :cascade do |t|
    t.bigint "city_id"
    t.bigint "cost_id"
    t.date "date_ocurrence"
    t.integer "type_launche"
    t.decimal "price"
    t.string "historic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_current_accounts_on_city_id"
    t.index ["cost_id"], name: "index_current_accounts_on_cost_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", null: false
    t.date "date_holiday", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_holiday"], name: "index_holidays_on_date_holiday", unique: true
  end

  create_table "item_advances", force: :cascade do |t|
    t.bigint "advance_id"
    t.string "parts"
    t.date "due_date", null: false
    t.decimal "price", precision: 9, scale: 2, null: false
    t.date "date_payment"
    t.decimal "value_payment"
    t.decimal "dalay", precision: 9, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["advance_id"], name: "index_item_advances_on_advance_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "advances", "clients"
  add_foreign_key "clients", "cities"
  add_foreign_key "current_accounts", "cities"
  add_foreign_key "current_accounts", "costs"
  add_foreign_key "item_advances", "advances"
  add_foreign_key "users", "cities"
end
