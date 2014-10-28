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

ActiveRecord::Schema.define(:version => 20121130032721) do

  create_table "billings", :force => true do |t|
    t.timestamp "created_on",                                                                    :null => false
    t.timestamp "updated_on",                                                                    :null => false
    t.string    "number",          :limit => 20
    t.date      "billing_date"
    t.integer   "person_id",       :limit => 11,                                :default => 0
    t.decimal   "amount",                        :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "outstanding",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal   "service_billing",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal   "expense_billing",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer   "days_of_ageing",  :limit => 11
    t.decimal   "business_tax",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string    "status",          :limit => 1,                                 :default => "0", :null => false
    t.integer   "collection_days", :limit => 11
    t.integer   "project_id",      :limit => 11,                                :default => 0,   :null => false
    t.integer   "period_id",       :limit => 11,                                :default => 0,   :null => false
    t.integer   "write_off",       :limit => 10, :precision => 10, :scale => 0,                  :null => false
    t.integer   "provision",       :limit => 10, :precision => 10, :scale => 0,                  :null => false
  end

  create_table "bookings", :force => true do |t|
    t.integer  "person_id",  :limit => 11
    t.integer  "hours",      :limit => 11, :default => 0
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id", :limit => 11
  end

  create_table "clients", :force => true do |t|
    t.string    "chinese_name"
    t.string    "english_name",                :default => ""
    t.integer   "person_id",    :limit => 11,  :default => 0,  :null => false
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
    t.integer   "gender1_id",   :limit => 11
    t.integer   "gender2_id",   :limit => 11
    t.string    "mobile_1",     :limit => 20
    t.string    "mobile_2",     :limit => 20
    t.string    "tel_1",        :limit => 30
    t.string    "tel_2",        :limit => 30
    t.string    "fax_1",        :limit => 20
    t.string    "fax_2",        :limit => 20
    t.string    "email_1"
    t.string    "email_2"
    t.string    "description"
    t.integer   "category_id",  :limit => 11
    t.integer   "status_id",    :limit => 11
    t.integer   "region_id",    :limit => 11
    t.integer   "industry_id",  :limit => 11
    t.string    "client_code",  :limit => 10,  :default => "", :null => false
    t.string    "person3",      :limit => 50,  :default => "", :null => false
    t.string    "title_3",      :limit => 50,  :default => "", :null => false
    t.integer   "gender3_id",   :limit => 11,  :default => 0,  :null => false
    t.string    "mobile_3",     :limit => 20,  :default => "", :null => false
    t.string    "tel_3",        :limit => 20,  :default => "", :null => false
    t.string    "fax_3",        :limit => 20,  :default => "", :null => false
    t.string    "email_3",      :limit => 50,  :default => "", :null => false
    t.timestamp "created_on",                                  :null => false
    t.timestamp "updated_on",                                  :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.integer  "commentable_id",                 :default => 0
    t.string   "commentable_type", :limit => 15, :default => ""
    t.integer  "user_id",                        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_fees", :primary_key => "period_id", :force => true do |t|
    t.integer  "id",         :limit => 10,                                :null => false
    t.integer  "person_id",  :limit => 11,                                :null => false
    t.integer  "common_fee", :limit => 10, :precision => 10, :scale => 0, :null => false
    t.datetime "created_on",                                              :null => false
    t.datetime "updated_on",                                              :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer "client_id", :limit => 11,  :default => 0,  :null => false
    t.string  "name",      :limit => 50,  :default => "", :null => false
    t.string  "title",     :limit => 50,  :default => "", :null => false
    t.integer "gender",    :limit => 11,  :default => 0,  :null => false
    t.string  "mobile",    :limit => 20,  :default => "", :null => false
    t.string  "tel",       :limit => 20,  :default => "", :null => false
    t.string  "fax",       :limit => 20,  :default => "", :null => false
    t.string  "email",     :limit => 50,  :default => "", :null => false
    t.string  "other",     :limit => 250, :default => "", :null => false
  end

  create_table "costs", :force => true do |t|
    t.decimal  "amount",                       :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "item_id",        :limit => 11,                                                 :null => false
    t.integer  "project_id",     :limit => 11,                                                 :null => false
    t.integer  "department_id",  :limit => 11,                                                 :null => false
    t.integer  "cost_status_id", :limit => 11,                                                 :null => false
    t.string   "description",                                                                  :null => false
    t.datetime "created_on",                                                                   :null => false
    t.datetime "updated_on",                                                                   :null => false
  end

  create_table "dicts", :force => true do |t|
    t.string "category", :limit => 50
    t.string "code",     :limit => 50
    t.string "title"
  end

  create_table "expenses", :force => true do |t|
    t.string   "expense_category"
    t.decimal  "fee"
    t.integer  "project_id"
    t.date     "charge_date"
    t.string   "state"
    t.string   "desc",             :default => ""
    t.integer  "period_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "billable",         :default => true
    t.integer  "person_id"
    t.integer  "approved_by"
  end

  create_table "incomes", :force => true do |t|
    t.integer  "item_id",        :limit => 11,                                                 :null => false
    t.integer  "project_id",     :limit => 11,                                                 :null => false
    t.integer  "department_id",  :limit => 11,                                                 :null => false
    t.decimal  "amount",                       :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer  "cost_status_id", :limit => 11,                                                 :null => false
    t.string   "description",                                                                  :null => false
    t.datetime "created_on",                                                                   :null => false
    t.datetime "updated_on",                                                                   :null => false
  end

  create_table "industries", :force => true do |t|
    t.string "code",  :limit => 50, :default => "", :null => false
    t.string "title",               :default => "", :null => false
  end

  create_table "people", :force => true do |t|
    t.datetime "created_on",                                     :null => false
    t.datetime "updated_on",                                     :null => false
    t.string   "chinese_name",    :limit => 50, :default => ""
    t.string   "english_name",    :limit => 50, :default => ""
    t.string   "employee_number", :limit => 10
    t.integer  "department_id",   :limit => 11
    t.string   "position",        :limit => 50
    t.decimal  "charge_rate",                   :default => 0.0
    t.date     "employment_date"
    t.string   "address"
    t.string   "postalcode",      :limit => 10
    t.string   "mobile",          :limit => 20
    t.string   "tel",             :limit => 20
    t.string   "extension",       :limit => 10
    t.string   "gender"
    t.integer  "status_id",       :limit => 11
    t.integer  "GMU_id",          :limit => 11, :default => 0
  end

  create_table "periods", :force => true do |t|
    t.string   "number",        :limit => 50, :default => "0", :null => false
    t.date     "starting_date",                                :null => false
    t.date     "ending_date",                                  :null => false
    t.datetime "created_on",                                   :null => false
    t.integer  "work_hours",    :limit => 11, :default => 0
  end

  create_table "personalcharges", :force => true do |t|
    t.datetime "created_on",                                       :null => false
    t.datetime "updated_on",                                       :null => false
    t.decimal  "hours",                     :default => 0.0,       :null => false
    t.decimal  "service_fee",               :default => 0.0,       :null => false
    t.integer  "project_id",  :limit => 11, :default => 0,         :null => false
    t.integer  "period_id",   :limit => 11, :default => 0,         :null => false
    t.integer  "person_id",   :limit => 11, :default => 0,         :null => false
    t.text     "desc"
    t.string   "state",                     :default => "pending", :null => false
    t.date     "charge_date"
    t.decimal  "ot_hours",                  :default => 0.0
  end

  create_table "prj_expense_logs", :force => true do |t|
    t.integer "prj_id",     :limit => 11
    t.integer "expense_id", :limit => 11
    t.integer "period_id",  :limit => 11
    t.string  "other",                    :null => false
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_on",                                                  :null => false
    t.datetime "updated_on",                                                  :null => false
    t.string   "contract_number",        :limit => 50, :default => "",        :null => false
    t.integer  "client_id",              :limit => 11, :default => 0,         :null => false
    t.integer  "GMU_id",                 :limit => 11, :default => 0,         :null => false
    t.integer  "service_id",             :limit => 11, :default => 0,         :null => false
    t.string   "job_code",               :limit => 20, :default => "",        :null => false
    t.string   "description",                          :default => ""
    t.date     "starting_date"
    t.date     "ending_date"
    t.decimal  "estimated_annual_fee",                 :default => 0.0,       :null => false
    t.integer  "risk_id",                :limit => 11
    t.integer  "manager_id",             :limit => 11
    t.decimal  "contracted_service_fee",               :default => 0.0,       :null => false
    t.decimal  "estimated_commision",                  :default => 0.0,       :null => false
    t.decimal  "estimated_outsorcing",                 :default => 0.0,       :null => false
    t.decimal  "budgeted_service_fee",                 :default => 0.0,       :null => false
    t.integer  "service_PFA",            :limit => 11, :default => 0,         :null => false
    t.integer  "expense_PFA",            :limit => 11, :default => 0,         :null => false
    t.decimal  "contracted_expense",                   :default => 0.0,       :null => false
    t.decimal  "budgeted_expense",                     :default => 0.0,       :null => false
    t.integer  "PFA_reason_id",          :limit => 11
    t.integer  "revenue_id",             :limit => 11, :default => 0,         :null => false
    t.integer  "estimated_hours",        :limit => 11, :default => 0
    t.string   "state",                                :default => "pending", :null => false
  end

  create_table "receive_amounts", :force => true do |t|
    t.datetime "created_on",                                                                     :null => false
    t.datetime "updated_on",                                                                     :null => false
    t.integer  "billing_id",     :limit => 11,                                 :default => 0,    :null => false
    t.string   "invoice_no",     :limit => 100,                                :default => "--", :null => false
    t.string   "receive_date",   :limit => 30,                                 :default => ""
    t.decimal  "receive_amount",                :precision => 10, :scale => 2, :default => 0.0,  :null => false
    t.string   "job_code",       :limit => 20
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
    t.integer  "person_id",                 :limit => 11
  end

end
