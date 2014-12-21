class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :chinese_name
      t.string :english_name
      t.string :employee_number
      t.integer :department_id
      t.string :grade
      t.decimal :charge_rate
      t.date :employeement_date
      t.string :address
      t.string :postalcode
      t.string :mobile
      t.string :tel
      t.string :extension
      t.integer :gender_id
      t.integer :status_id
      t.integer :GMU_id
    end
  end
end
