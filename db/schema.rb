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

ActiveRecord::Schema.define(version: 20150108120812) do

  create_table "billings", force: :cascade do |t|
    t.datetime "created_on",                                                        null: false
    t.datetime "updated_on",                                                        null: false
    t.string   "number",          limit: 20
    t.date     "billing_date"
    t.decimal  "amount",                     precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "outstanding",                precision: 10, scale: 2, default: 0.0
    t.decimal  "service_billing",            precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "expense_billing",            precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "days_of_ageing",  limit: 11
    t.decimal  "business_tax",               precision: 10, scale: 2, default: 0.0, null: false
    t.string   "status",          limit: 1,                           default: "0"
    t.integer  "collection_days", limit: 11
    t.integer  "project_id",      limit: 11,                          default: 0,   null: false
    t.integer  "period_id",       limit: 11,                          default: 0,   null: false
    t.integer  "write_off",       limit: 10,                                        null: false
    t.integer  "provision",       limit: 10,                                        null: false
    t.integer  "user_id"
    t.integer  "person_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "hours",      limit: 11, default: 0
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id", limit: 11
    t.integer  "user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "chinese_name", limit: 255
    t.string   "english_name", limit: 255, default: ""
    t.string   "description",  limit: 255
    t.integer  "category_id",  limit: 11
    t.integer  "status_id",    limit: 11
    t.integer  "region_id",    limit: 11
    t.integer  "industry_id",  limit: 11
    t.string   "client_code",  limit: 10,  default: "", null: false
    t.datetime "created_on",                            null: false
    t.datetime "updated_on",                            null: false
    t.integer  "user_id"
    t.integer  "person_id"
    t.string   "address_1",    limit: 255
    t.string   "person1",      limit: 255
    t.string   "person2",      limit: 255
    t.string   "address_2",    limit: 255
    t.string   "city_1",       limit: 255
    t.string   "city_2",       limit: 255
    t.string   "state_1",      limit: 255
    t.string   "state_2",      limit: 255
    t.string   "country_1",    limit: 255
    t.string   "country_2",    limit: 255
    t.string   "postalcode_1", limit: 255
    t.string   "postalcode_2", limit: 255
    t.string   "title_1",      limit: 255
    t.string   "title_2",      limit: 255
    t.string   "gender1_id",   limit: 255
    t.string   "gender2_id",   limit: 255
    t.string   "mobile_1",     limit: 255
    t.string   "mobile_2",     limit: 255
    t.string   "tel_1",        limit: 255
    t.string   "tel_2",        limit: 255
    t.string   "fax_1",        limit: 255
    t.string   "fax_2",        limit: 255
    t.string   "email_1",      limit: 255
    t.string   "email_2",      limit: 255
    t.string   "person3",      limit: 255
    t.string   "title_3",      limit: 255
    t.string   "gender3_id",   limit: 255
    t.string   "mobile_3",     limit: 255
    t.string   "tel_3",        limit: 255
    t.string   "fax_3",        limit: 255
    t.string   "email_3",      limit: 255
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,  default: ""
    t.text     "comment",          limit: 255, default: ""
    t.integer  "commentable_id",               default: 0
    t.string   "commentable_type", limit: 15,  default: ""
    t.integer  "user_id",                      default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "common_fees", primary_key: "period_id", force: :cascade do |t|
    t.integer  "id",         limit: 10,                null: false
    t.integer  "person_id",  limit: 11,                null: false
    t.decimal  "common_fee",            precision: 10, null: false
    t.datetime "created_on",                           null: false
    t.datetime "updated_on",                           null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "client_id",  limit: 11,  default: 0,  null: false
    t.string  "name",       limit: 50,  default: "", null: false
    t.string  "title",      limit: 50,  default: "", null: false
    t.integer "gender",     limit: 11,  default: 0,  null: false
    t.string  "mobile",     limit: 20,  default: "", null: false
    t.string  "tel",        limit: 20,  default: "", null: false
    t.string  "fax",        limit: 20,  default: "", null: false
    t.string  "email",      limit: 50,  default: "", null: false
    t.string  "other",      limit: 250, default: "", null: false
    t.text    "address"
    t.string  "city",       limit: 255
    t.string  "state",      limit: 255
    t.string  "country",    limit: 255
    t.string  "postalcode", limit: 255
  end

  create_table "costs", force: :cascade do |t|
    t.decimal  "amount",                     precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "item_id",        limit: 11,                                         null: false
    t.integer  "project_id",     limit: 11,                                         null: false
    t.integer  "department_id",  limit: 11,                                         null: false
    t.integer  "cost_status_id", limit: 11,                                         null: false
    t.string   "description",    limit: 255,                                        null: false
    t.datetime "created_on",                                                        null: false
    t.datetime "updated_on",                                                        null: false
  end

  create_table "deductions", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "service_PFA"
    t.decimal  "service_UFA"
    t.decimal  "service_billing"
    t.decimal  "expense_PFA"
    t.decimal  "expense_UFA"
    t.decimal  "expense_billing"
    t.integer  "project_id"
  end

  create_table "dicts", force: :cascade do |t|
    t.string "category", limit: 50
    t.string "code",     limit: 50
    t.string "title",    limit: 255
  end

  create_table "expenses", force: :cascade do |t|
    t.string   "expense_category",   limit: 255
    t.decimal  "fee"
    t.integer  "project_id"
    t.date     "charge_date"
    t.string   "state",              limit: 255
    t.string   "desc",               limit: 255, default: ""
    t.integer  "period_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "billable",                       default: true
    t.integer  "approved_by"
    t.integer  "user_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "commission"
    t.decimal  "outsourcing"
    t.decimal  "tickets"
    t.decimal  "courrier"
    t.decimal  "postage"
    t.decimal  "stationery"
    t.decimal  "report_binding"
    t.decimal  "cash_advance"
    t.decimal  "payment_on_be_half"
    t.string   "memo",               limit: 255
  end

  create_table "incomes", force: :cascade do |t|
    t.integer  "item_id",        limit: 11,                                         null: false
    t.integer  "project_id",     limit: 11,                                         null: false
    t.integer  "department_id",  limit: 11,                                         null: false
    t.decimal  "amount",                     precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "cost_status_id", limit: 11,                                         null: false
    t.string   "description",    limit: 255,                                        null: false
    t.datetime "created_on",                                                        null: false
    t.datetime "updated_on",                                                        null: false
  end

  create_table "industries", force: :cascade do |t|
    t.string "code",  limit: 50,  default: "", null: false
    t.string "title", limit: 255, default: "", null: false
  end

  create_table "initialfees", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "service_fee"
    t.decimal  "commission"
    t.decimal  "outsourcing"
    t.decimal  "reimbursement"
    t.decimal  "meal_allowance"
    t.decimal  "travel_allowance"
    t.decimal  "business_tax"
    t.decimal  "tickets"
    t.decimal  "courrier"
    t.decimal  "postage"
    t.decimal  "stationery"
    t.decimal  "report_binding"
    t.decimal  "payment_on_be_half"
    t.integer  "project_id"
    t.decimal  "cash_advance"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "chinese_name",      limit: 255
    t.string   "english_name",      limit: 255
    t.string   "employee_number",   limit: 255
    t.integer  "department_id"
    t.string   "grade",             limit: 255
    t.decimal  "charge_rate"
    t.date     "employeement_date"
    t.string   "address",           limit: 255
    t.string   "postalcode",        limit: 255
    t.string   "mobile",            limit: 255
    t.string   "tel",               limit: 255
    t.string   "extension",         limit: 255
    t.integer  "gender_id"
    t.integer  "status_id"
    t.integer  "GMU_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string   "number",        limit: 50, default: "0", null: false
    t.date     "starting_date",                          null: false
    t.date     "ending_date",                            null: false
    t.datetime "created_on",                             null: false
    t.integer  "work_hours",    limit: 11, default: 0
  end

  create_table "personalcharges", force: :cascade do |t|
    t.datetime "created_on",                                       null: false
    t.datetime "updated_on",                                       null: false
    t.decimal  "hours",                        default: 0.0,       null: false
    t.decimal  "service_fee",                  default: 0.0,       null: false
    t.integer  "project_id",       limit: 11,  default: 0,         null: false
    t.integer  "period_id",        limit: 11,  default: 0,         null: false
    t.text     "desc"
    t.string   "state",            limit: 255, default: "pending", null: false
    t.date     "charge_date"
    t.decimal  "ot_hours",                     default: 0.0
    t.integer  "user_id"
    t.decimal  "reimbursement"
    t.decimal  "meal_allowance"
    t.decimal  "travel_allowance"
    t.integer  "person_id"
  end

  create_table "prj_expense_logs", force: :cascade do |t|
    t.integer "prj_id",     limit: 11
    t.integer "expense_id", limit: 11
    t.integer "period_id",  limit: 11
    t.string  "other",      limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_on",                                             null: false
    t.datetime "updated_on",                                             null: false
    t.string   "contract_number",        limit: 50,  default: ""
    t.integer  "client_id",              limit: 11,  default: 0,         null: false
    t.integer  "GMU_id",                 limit: 11,  default: 0,         null: false
    t.integer  "service_id",             limit: 11,  default: 0,         null: false
    t.string   "job_code",               limit: 20,  default: ""
    t.string   "description",            limit: 255, default: ""
    t.date     "starting_date"
    t.date     "ending_date"
    t.decimal  "estimated_annual_fee",               default: 0.0,       null: false
    t.integer  "risk_id",                limit: 11
    t.integer  "manager_id",             limit: 11
    t.decimal  "contracted_service_fee",             default: 0.0,       null: false
    t.decimal  "estimated_commision",                default: 0.0,       null: false
    t.decimal  "estimated_outsorcing",               default: 0.0,       null: false
    t.decimal  "budgeted_service_fee",               default: 0.0,       null: false
    t.integer  "service_PFA",            limit: 11,  default: 0,         null: false
    t.integer  "expense_PFA",            limit: 11,  default: 0,         null: false
    t.decimal  "contracted_expense",                 default: 0.0,       null: false
    t.decimal  "budgeted_expense",                   default: 0.0,       null: false
    t.integer  "PFA_reason_id",          limit: 11
    t.integer  "revenue_id",             limit: 11,  default: 0,         null: false
    t.integer  "estimated_hours",        limit: 11,  default: 0
    t.string   "state",                  limit: 255, default: "pending", null: false
    t.integer  "status_id"
    t.integer  "partner_id"
    t.integer  "referring_id"
    t.integer  "billing_partner_id"
    t.integer  "billing_manager_id"
  end

  create_table "receive_amounts", force: :cascade do |t|
    t.datetime "created_on",                                                         null: false
    t.datetime "updated_on",                                                         null: false
    t.integer  "billing_id",     limit: 11,                           default: 0,    null: false
    t.string   "invoice_no",     limit: 100,                          default: "--", null: false
    t.string   "receive_date",   limit: 30,                           default: ""
    t.decimal  "receive_amount",             precision: 10, scale: 2, default: 0.0,  null: false
    t.string   "job_code",       limit: 20
  end

  create_table "ufafees", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "number",      limit: 255
    t.decimal  "amount"
    t.integer  "project_id"
    t.string   "period_id",   limit: 255
    t.decimal  "service_UFA"
    t.decimal  "expense_UFA"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 40
    t.string   "name",                      limit: 100, default: ""
    t.string   "email",                     limit: 100
    t.string   "encrypted_password",        limit: 128, default: "",         null: false
    t.string   "password_salt",             limit: 40,  default: "",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "roles",                     limit: 255, default: "employee"
    t.integer  "person_id",                 limit: 11
    t.datetime "remember_created_at"
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                         default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.string   "english_name",              limit: 255
    t.string   "employee_number",           limit: 255
    t.integer  "department_id"
    t.string   "position",                  limit: 255
    t.decimal  "charge_rate"
    t.date     "employment_date"
    t.string   "address",                   limit: 255
    t.string   "postalcode",                limit: 255
    t.string   "mobile",                    limit: 255
    t.string   "tel",                       limit: 255
    t.string   "extension",                 limit: 255
    t.string   "gender",                    limit: 255
    t.integer  "status_id"
    t.integer  "GMU_id"
    t.string   "hashed_password",           limit: 255
    t.string   "auth",                      limit: 255
    t.string   "other1",                    limit: 255
    t.string   "other2",                    limit: 255
    t.string   "status"
    t.string   "department"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
