# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151130232117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.integer "unit_id"
    t.integer "taxpayer_id"
    t.integer "year"
    t.string  "nr_document"
    t.string  "name"
    t.string  "address"
    t.string  "state"
    t.string  "city"
    t.float   "vtnt"
    t.float   "area"
    t.float   "modulo"
    t.float   "degree_of_use"
    t.float   "usable_area"
  end

  add_index "areas", ["taxpayer_id"], name: "index_areas_on_taxpayer_id", using: :btree
  add_index "areas", ["unit_id"], name: "index_areas_on_unit_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.string   "state"
    t.integer  "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "fl_charge"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "cnpj"
    t.string   "zipcode"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "phone"
    t.string   "email"
    t.decimal  "fee",          precision: 5, scale: 2
    t.integer  "unit_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "cnas", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "taxpayer_id"
    t.integer  "year"
    t.string   "nr_document"
    t.float    "amount"
    t.integer  "stage"
    t.integer  "status"
    t.datetime "start_at"
    t.datetime "due_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "fl_charge"
    t.integer  "contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "taxpayer_id"
    t.integer  "employee_id"
    t.float    "unit_amount"
    t.decimal  "unit_fee"
    t.integer  "unit_ticket_quantity"
    t.float    "client_amount"
    t.integer  "client_ticket_quantity"
    t.datetime "contract_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.date     "unit_due"
    t.date     "client_due"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.decimal  "fee",        precision: 5, scale: 2
    t.integer  "unit_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "histories", force: :cascade do |t|
    t.string   "description"
    t.datetime "history_date"
    t.integer  "unit_id"
    t.integer  "category_id"
    t.integer  "taxpayer_id"
    t.integer  "employee_id"
    t.integer  "task_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "indices", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "month"
    t.integer  "year"
    t.decimal  "idx",        precision: 5,  scale: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "change",     precision: 10, scale: 4
  end

  add_index "indices", ["unit_id"], name: "index_indices_on_unit_id", using: :btree

  create_table "inpcs", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "month"
    t.integer  "year"
    t.decimal  "idx",        precision: 10, scale: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "inpcs", ["unit_id"], name: "index_inpcs_on_unit_id", using: :btree

  create_table "lawyers", force: :cascade do |t|
    t.string   "name"
    t.string   "lawyer_code"
    t.string   "cpf"
    t.string   "cnpj"
    t.string   "phone"
    t.string   "zipcode"
    t.string   "address"
    t.string   "state"
    t.string   "city"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "unit_id"
  end

  add_index "lawyers", ["unit_id"], name: "index_lawyers_on_unit_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.datetime "task_date"
    t.string   "description"
    t.integer  "unit_id"
    t.integer  "employee_id"
    t.integer  "taxpayer_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "taxpayers", force: :cascade do |t|
    t.string   "name"
    t.string   "cpf"
    t.string   "zipcode"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "complement"
    t.string   "neighborhood"
    t.integer  "unit_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "client_id"
    t.string   "cnpj"
    t.integer  "origin_code"
    t.string   "phone"
    t.integer  "city_id"
  end

  add_index "taxpayers", ["client_id"], name: "index_taxpayers_on_client_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "contract_id"
    t.integer  "ticket_type"
    t.float    "amount"
    t.integer  "ticket_number"
    t.datetime "due"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "cnpj"
    t.string   "zipcode"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "unit_fee"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "unit_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "profile"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "areas", "taxpayers"
  add_foreign_key "areas", "units"
  add_foreign_key "indices", "units"
  add_foreign_key "inpcs", "units"
  add_foreign_key "lawyers", "units"
  add_foreign_key "taxpayers", "clients"
end
