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

ActiveRecord::Schema.define(version: 20161014231214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "taxpayer_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["task_id"], name: "index_activities_on_task_id", using: :btree
    t.index ["taxpayer_id"], name: "index_activities_on_taxpayer_id", using: :btree
  end

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
    t.index ["taxpayer_id"], name: "index_areas_on_taxpayer_id", using: :btree
    t.index ["unit_id"], name: "index_areas_on_unit_id", using: :btree
  end

  create_table "bank_billet_accounts", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.integer  "bank_billet_account"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["unit_id"], name: "index_bank_billet_accounts_on_unit_id", using: :btree
  end

  create_table "bank_billets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "bank_billet_account_id"
    t.integer  "origin_code"
    t.string   "our_number"
    t.float    "amount"
    t.date     "expire_at"
    t.string   "customer_person_name"
    t.string   "customer_cnpj_cpf"
    t.integer  "status"
    t.date     "paid_at"
    t.float    "paid_amount"
    t.string   "shorten_url"
    t.float    "fine_for_delay"
    t.float    "late_payment_interest"
    t.date     "document_date"
    t.float    "document_amount"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["bank_billet_account_id"], name: "index_bank_billets_on_bank_billet_account_id", using: :btree
    t.index ["unit_id"], name: "index_bank_billets_on_unit_id", using: :btree
  end

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
    t.decimal  "fee",                    precision: 5, scale: 2
    t.integer  "unit_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "bank_billet_account_id"
    t.index ["bank_billet_account_id"], name: "index_clients_on_bank_billet_account_id", using: :btree
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
    t.integer  "proposal_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_cnas_on_client_id", using: :btree
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
    t.integer  "status"
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "origin_code"
    t.string   "description"
    t.index ["client_id"], name: "index_contracts_on_client_id", using: :btree
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
    t.integer  "user_id"
    t.integer  "word_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_histories_on_client_id", using: :btree
    t.index ["word_id"], name: "index_histories_on_word_id", using: :btree
  end

  create_table "indices", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "month"
    t.integer  "year"
    t.decimal  "idx",        precision: 5,  scale: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "change",     precision: 10, scale: 4
    t.index ["unit_id"], name: "index_indices_on_unit_id", using: :btree
  end

  create_table "inpcs", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "month"
    t.integer  "year"
    t.decimal  "idx",        precision: 10, scale: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.date     "idx_date"
    t.index ["unit_id"], name: "index_inpcs_on_unit_id", using: :btree
  end

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
    t.index ["unit_id"], name: "index_lawyers_on_unit_id", using: :btree
  end

  create_table "proposal_tickets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "proposal_id"
    t.integer  "ticket_type"
    t.float    "amount"
    t.integer  "ticket_number"
    t.date     "due_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "user_id"
    t.integer  "taxpayer_id"
    t.integer  "employee_id"
    t.float    "unit_amount"
    t.float    "unit_fee"
    t.integer  "unit_ticket_quantity"
    t.integer  "client_ticket_quantity"
    t.float    "client_amount"
    t.date     "unit_due_at"
    t.date     "client_due_at"
    t.integer  "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "contract_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_proposals_on_client_id", using: :btree
  end

  create_table "redistributeds", force: :cascade do |t|
    t.integer  "taxpayer_id"
    t.integer  "user_prev_id"
    t.integer  "user_id"
    t.integer  "unit_id"
    t.datetime "distributed_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

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
    t.integer  "user_id"
    t.integer  "status"
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "taxpayer_contacts", force: :cascade do |t|
    t.integer  "taxpayer_id"
    t.string   "name"
    t.string   "description"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["taxpayer_id"], name: "index_taxpayer_contacts_on_taxpayer_id", using: :btree
  end

  create_table "taxpayer_phones", force: :cascade do |t|
    t.integer  "taxpayer_id"
    t.string   "phone"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["taxpayer_id"], name: "index_taxpayer_phones_on_taxpayer_id", using: :btree
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
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "client_id"
    t.string   "cnpj"
    t.integer  "origin_code"
    t.string   "phone"
    t.integer  "city_id"
    t.integer  "employee_id"
    t.integer  "user_id"
    t.date     "distributed_at"
    t.index ["client_id"], name: "index_taxpayers_on_client_id", using: :btree
    t.index ["employee_id"], name: "index_taxpayers_on_employee_id", using: :btree
    t.index ["user_id"], name: "index_taxpayers_on_user_id", using: :btree
  end

  create_table "temp_cna", force: :cascade do |t|
    t.integer "cod_proprietario"
    t.string  "num_uf"
    t.string  "exercicio"
    t.integer "sequencial"
    t.string  "nom_proprietario"
    t.string  "tip_pessoa"
    t.string  "endereco"
    t.string  "bairro"
    t.string  "cep"
    t.string  "nom_municipio"
    t.string  "sigla_uf"
    t.string  "val_cna"
    t.string  "val_multa_cna"
    t.string  "val_juros_cna"
    t.string  "total"
    t.date    "dat_vencimento"
    t.string  "tip_cobranca"
  end

  create_table "temp_indices", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.decimal "idx_c", precision: 8, scale: 4
    t.decimal "idx_d", precision: 8, scale: 4
    t.decimal "idx_e", precision: 8, scale: 4
    t.decimal "idx_f", precision: 8, scale: 4
    t.decimal "idx_g", precision: 8, scale: 4
    t.decimal "idx_h", precision: 8, scale: 4
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "contract_id"
    t.integer  "ticket_type"
    t.float    "amount"
    t.integer  "ticket_number"
    t.datetime "due"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "bank_billet_id"
    t.integer  "status"
    t.date     "paid_at"
    t.float    "paid_amount"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_tickets_on_client_id", using: :btree
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
    t.boolean  "fl_correcao"
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
    t.integer  "employee_id"
    t.string   "name"
    t.string   "phone"
    t.datetime "deleted_at"
    t.boolean  "fl_taxpayer"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["employee_id"], name: "index_users_on_employee_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_words_on_unit_id", using: :btree
  end

  add_foreign_key "activities", "tasks"
  add_foreign_key "activities", "taxpayers"
  add_foreign_key "areas", "taxpayers"
  add_foreign_key "areas", "units"
  add_foreign_key "bank_billet_accounts", "units"
  add_foreign_key "bank_billets", "bank_billet_accounts"
  add_foreign_key "bank_billets", "units"
  add_foreign_key "clients", "bank_billet_accounts"
  add_foreign_key "cnas", "clients"
  add_foreign_key "contracts", "clients"
  add_foreign_key "histories", "clients"
  add_foreign_key "histories", "words"
  add_foreign_key "indices", "units"
  add_foreign_key "inpcs", "units"
  add_foreign_key "lawyers", "units"
  add_foreign_key "proposals", "clients"
  add_foreign_key "tasks", "users"
  add_foreign_key "taxpayer_contacts", "taxpayers"
  add_foreign_key "taxpayer_phones", "taxpayers"
  add_foreign_key "taxpayers", "clients"
  add_foreign_key "taxpayers", "employees"
  add_foreign_key "taxpayers", "users"
  add_foreign_key "tickets", "clients"
  add_foreign_key "users", "employees"
  add_foreign_key "words", "units"
end
