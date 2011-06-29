# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110610030642) do

  create_table "billings", :force => true do |t|
    t.timestamp "created_on",                                                                    :null => false
    t.timestamp "updated_on",                                                                    :null => false
    t.string    "number",          :limit => 20
    t.date      "billing_date"
    t.integer   "person_id",                                                    :default => 0
    t.decimal   "amount",                        :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "outstanding",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal   "service_billing",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "expense_billing",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "days_of_ageing"
    t.decimal   "business_tax",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string    "status",          :limit => 1,                                 :default => "0", :null => false
    t.integer   "collection_days"
    t.integer   "project_id",                                                   :default => 0,   :null => false
    t.integer   "period_id",                                                    :default => 0,   :null => false
    t.integer   "write_off",       :limit => 10, :precision => 10, :scale => 0,                  :null => false
    t.integer   "provision",       :limit => 10, :precision => 10, :scale => 0,                  :null => false
  end

  add_index "billings", ["project_id", "period_id"], :name => "billing_id"

  create_table "bookings", :force => true do |t|
    t.integer  "person_id"
    t.integer  "hours",      :default => 0
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "clients", :force => true do |t|
    t.string    "chinese_name"
    t.string    "english_name",                :default => ""
    t.integer   "person_id",                   :default => 0,  :null => false
    t.string    "address_1"
    t.string    "person1",      :limit => 50
    t.string    "person2",      :limit => 50
    t.string    "address_2"
    t.string    "city_1"
    t.string    "city_2"
    t.string    "state_1"
    t.string    "state_2"
    t.string    "country_1",    :limit => 100
    t.string    "country_2",    :limit => 100
    t.string    "postalcode_1", :limit => 20
    t.string    "postalcode_2", :limit => 20
    t.string    "title_1",      :limit => 50
    t.string    "title_2",      :limit => 50
    t.integer   "gender1_id"
    t.integer   "gender2_id"
    t.string    "mobile_1",     :limit => 20
    t.string    "mobile_2",     :limit => 20
    t.string    "tel_1",        :limit => 30
    t.string    "tel_2",        :limit => 30
    t.string    "fax_1",        :limit => 20
    t.string    "fax_2",        :limit => 20
    t.string    "email_1"
    t.string    "email_2"
    t.string    "description"
    t.integer   "category_id"
    t.integer   "status_id"
    t.integer   "region_id"
    t.integer   "industry_id"
    t.string    "client_code",  :limit => 10,  :default => "", :null => false
    t.string    "person3",      :limit => 50,  :default => "", :null => false
    t.string    "title_3",      :limit => 50,  :default => "", :null => false
    t.integer   "gender3_id",                  :default => 0,  :null => false
    t.string    "mobile_3",     :limit => 20,  :default => "", :null => false
    t.string    "tel_3",        :limit => 20,  :default => "", :null => false
    t.string    "fax_3",        :limit => 20,  :default => "", :null => false
    t.string    "email_3",      :limit => 50,  :default => "", :null => false
    t.timestamp "created_on",                                  :null => false
    t.timestamp "updated_on",                                  :null => false
  end

  add_index "clients", ["client_code"], :name => "client_code"
  add_index "clients", ["person_id", "gender1_id", "gender2_id", "category_id", "status_id", "region_id", "industry_id", "gender3_id"], :name => "client_id"

  create_table "common_fees", :id => false, :force => true do |t|
    t.integer  "period_id",                                               :null => false
    t.integer  "id",                                                      :null => false
    t.integer  "person_id",                                               :null => false
    t.integer  "common_fee", :limit => 10, :precision => 10, :scale => 0, :null => false
    t.datetime "created_on",                                              :null => false
    t.datetime "updated_on",                                              :null => false
  end

  add_index "common_fees", ["period_id", "person_id"], :name => "common_fees_index1297"

  create_table "contacts", :force => true do |t|
    t.integer "client_id",                :default => 0,  :null => false
    t.string  "name",      :limit => 50,  :default => "", :null => false
    t.string  "title",     :limit => 50,  :default => "", :null => false
    t.integer "gender",                   :default => 0,  :null => false
    t.string  "mobile",    :limit => 20,  :default => "", :null => false
    t.string  "tel",       :limit => 20,  :default => "", :null => false
    t.string  "fax",       :limit => 20,  :default => "", :null => false
    t.string  "email",     :limit => 50,  :default => "", :null => false
    t.string  "other",     :limit => 250, :default => "", :null => false
  end

  create_table "costs", :force => true do |t|
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "item_id",                                                        :null => false
    t.integer  "project_id",                                                     :null => false
    t.integer  "department_id",                                                  :null => false
    t.integer  "cost_status_id",                                                 :null => false
    t.string   "description",                                   :default => "",  :null => false
    t.datetime "created_on",                                                     :null => false
    t.datetime "updated_on",                                                     :null => false
  end

  create_table "deductions", :force => true do |t|
    t.timestamp "created_on",                                                      :null => false
    t.timestamp "updated_on",                                                      :null => false
    t.decimal   "service_PFA",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "service_UFA",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "service_billing", :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "expense_PFA",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "expense_UFA",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "expense_billing", :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "project_id",                                     :default => 0,   :null => false
  end

  create_table "dicts", :force => true do |t|
    t.string "category", :limit => 50
    t.string "code",     :limit => 50
    t.string "title"
  end

  add_index "dicts", ["code"], :name => "code"

  create_table "expense_items", :force => true do |t|
    t.integer  "expense_id",                                                     :null => false
    t.integer  "expensetype_id",                                                 :null => false
    t.decimal  "fee",            :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expense_items", ["expense_id"], :name => "fk_item_expense"
  add_index "expense_items", ["expensetype_id"], :name => "expensetype"

  create_table "expenses", :force => true do |t|
    t.timestamp "created_on",                                                           :null => false
    t.timestamp "updated_on",                                                           :null => false
    t.decimal   "commission",         :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "outsourcing",        :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "tickets",            :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "courrier",           :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "postage",            :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "stationery",         :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "report_binding",     :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal   "cash_advance",       :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.integer   "period_id",                                         :default => 0,     :null => false
    t.integer   "project_id",                                        :default => 0,     :null => false
    t.decimal   "payment_on_be_half", :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.string    "memo"
    t.boolean   "audit_flag",                                        :default => false
    t.boolean   "audit_flag1",                                       :default => false
  end

  add_index "expenses", ["period_id", "project_id"], :name => "expense_id"

  create_table "expensetypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incomes", :force => true do |t|
    t.integer  "item_id",                                                        :null => false
    t.integer  "project_id",                                                     :null => false
    t.integer  "department_id",                                                  :null => false
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "cost_status_id",                                                 :null => false
    t.string   "description",                                   :default => "",  :null => false
    t.datetime "created_on",                                                     :null => false
    t.datetime "updated_on",                                                     :null => false
  end

  create_table "industries", :force => true do |t|
    t.string "code",  :limit => 50, :default => "", :null => false
    t.string "title",               :default => "", :null => false
  end

  create_table "people", :force => true do |t|
    t.timestamp "created_on",                                                                    :null => false
    t.timestamp "updated_on",                                                                    :null => false
    t.string    "chinese_name",    :limit => 50,                                :default => ""
    t.string    "english_name",    :limit => 50,                                :default => ""
    t.string    "employee_number", :limit => 10
    t.integer   "department_id"
    t.string    "grade",           :limit => 50
    t.decimal   "charge_rate",                   :precision => 10, :scale => 2, :default => 0.0
    t.date      "employment_date"
    t.string    "address"
    t.string    "postalcode",      :limit => 10
    t.string    "mobile",          :limit => 20
    t.string    "tel",             :limit => 20
    t.string    "extension",       :limit => 10
    t.string    "gender"
    t.integer   "status_id"
    t.integer   "GMU_id",                                                       :default => 0
  end

  add_index "people", ["department_id", "gender", "status_id", "GMU_id"], :name => "person_id"

  create_table "periods", :force => true do |t|
    t.string   "number",        :limit => 50, :default => "0", :null => false
    t.date     "starting_date",                                :null => false
    t.date     "ending_date",                                  :null => false
    t.datetime "created_on",                                   :null => false
    t.integer  "work_hours",                  :default => 0
  end

  create_table "personalcharges", :force => true do |t|
    t.timestamp "created_on",                                                       :null => false
    t.timestamp "updated_on",                                                       :null => false
    t.decimal   "hours",            :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "service_fee",      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "reimbursement",    :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "meal_allowance",   :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "travel_allowance", :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "project_id",                                      :default => 0,   :null => false
    t.integer   "period_id",                                       :default => 0,   :null => false
    t.integer   "person_id",                                       :default => 0,   :null => false
    t.text      "desc"
    t.string    "state"
  end

  add_index "personalcharges", ["project_id", "period_id", "person_id"], :name => "personalchg_id"

  create_table "prj_expense_logs", :force => true do |t|
    t.integer "prj_id"
    t.integer "expense_id"
    t.integer "period_id"
    t.string  "other",      :default => "", :null => false
  end

  create_table "projects", :force => true do |t|
    t.timestamp "created_on",                                                                           :null => false
    t.timestamp "updated_on",                                                                           :null => false
    t.string    "contract_number",        :limit => 50,                                :default => "",  :null => false
    t.integer   "client_id",                                                           :default => 0,   :null => false
    t.integer   "GMU_id",                                                              :default => 0,   :null => false
    t.integer   "service_id",                                                          :default => 0,   :null => false
    t.string    "job_code",               :limit => 20,                                :default => "",  :null => false
    t.string    "description",                                                         :default => ""
    t.date      "starting_date"
    t.date      "ending_date"
    t.decimal   "estimated_annual_fee",                 :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "risk_id"
    t.integer   "status_id"
    t.integer   "partner_id"
    t.integer   "manager_id"
    t.integer   "referring_id"
    t.integer   "billing_partner_id",                                                  :default => 0,   :null => false
    t.integer   "billing_manager_id",                                                  :default => 0,   :null => false
    t.decimal   "contracted_service_fee",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "estimated_commision",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "estimated_outsorcing",                 :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "budgeted_service_fee",                 :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "service_PFA",                                                         :default => 0,   :null => false
    t.integer   "expense_PFA",                                                         :default => 0,   :null => false
    t.decimal   "contracted_expense",                   :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "budgeted_expense",                     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "PFA_reason_id"
    t.integer   "revenue_id",                                                          :default => 0,   :null => false
    t.integer   "estimated_hours",                                                     :default => 0
    t.string    "state"
  end

  add_index "projects", ["client_id", "GMU_id", "service_id", "risk_id", "status_id", "partner_id", "manager_id", "referring_id", "billing_partner_id", "billing_manager_id", "PFA_reason_id", "revenue_id"], :name => "prj_other_id"
  add_index "projects", ["job_code"], :name => "job_code"

  create_table "receive_amounts", :force => true do |t|
    t.datetime "created_on",                                                                     :null => false
    t.datetime "updated_on",                                                                     :null => false
    t.integer  "billing_id",                                                   :default => 0,    :null => false
    t.string   "invoice_no",     :limit => 100,                                :default => "--", :null => false
    t.string   "receive_date",   :limit => 30,                                 :default => ""
    t.decimal  "receive_amount",                :precision => 10, :scale => 2, :default => 0.0,  :null => false
    t.string   "job_code",       :limit => 20
  end

  create_table "ufafees", :force => true do |t|
    t.timestamp "created_on",                                                  :null => false
    t.timestamp "updated_on",                                                  :null => false
    t.string    "number"
    t.decimal   "amount",      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "project_id"
    t.integer   "period_id"
    t.decimal   "service_UFA", :precision => 10, :scale => 2, :default => 0.0
    t.decimal   "expense_UFA", :precision => 10, :scale => 2, :default => 0.0
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "roles",                                    :default => "employee"
    t.integer  "person_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
