class MovePeopleToUsers < ActiveRecord::Migration
  def up
    change_table "users" do |t|
      t.string   "english_name"
      t.string   "employee_number"
      t.integer  "department_id"
      t.string   "position"
      t.decimal  "charge_rate"
      t.date     "employment_date"
      t.string   "address"
      t.string   "postalcode"
      t.string   "mobile"
      t.string   "tel"
      t.string   "extension"
      t.string   "gender"
      t.integer  "status_id"
      t.integer  "GMU_id"
    end

    Person.all.each do |person|
      user = User.new
      if User.find_by_person_id(person.id)
        user = User.find_by_person_id(person.id)
      else
        user.email            = "#{person.employee_number}#{person.english_name.split.first}@example.com"
        user.password         = "11111111"
        user.name             = person.chinese_name
        user.login            = person.english_name
        user.roles            = "employee"
      end
      user.english_name     = person.english_name.split.first
      user.employee_number  = person.employee_number
      user.department_id    = person.department_id
      user.position         = person.position
      user.charge_rate      = person.charge_rate
      user.employment_date  = person.employment_date
      user.address          = person.address
      user.postalcode       = person.postalcode
      user.mobile           = person.mobile
      user.tel              = person.tel
      user.extension        = person.extension
      user.gender           = person.gender
      user.status_id        = person.status_id
      user.GMU_id           = person.GMU_id
      user.save!
    end
    drop_table :people
  end

  def down
    create_table "people", :force => true do |t|
      t.timestamps
      t.string   "chinese_name"
      t.string   "english_name"
      t.string   "employee_number"
      t.integer  "department_id"
      t.string   "position"
      t.decimal  "charge_rate"
      t.date     "employment_date"
      t.string   "address"
      t.string   "postalcode"
      t.string   "mobile"
      t.string   "tel"
      t.string   "extension"
      t.string   "gender"
      t.integer  "status_id"
      t.integer  "GMU_id"
    end

    change_table "users" do |t|
      t.remove   "english_name"
      t.remove   "employee_number"
      t.remove   "department_id"
      t.remove   "position"
      t.remove   "charge_rate"
      t.remove   "employment_date"
      t.remove   "address"
      t.remove   "postalcode"
      t.remove   "mobile"
      t.remove   "tel"
      t.remove   "extension"
      t.remove   "gender"
      t.remove   "status_id"
      t.remove   "GMU_id"
    end
  end
end
