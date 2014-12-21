class CreateDeductions < ActiveRecord::Migration
  def change
    create_table :deductions do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :service_PFA
      t.decimal :service_UFA
      t.decimal :service_billing
      t.decimal :expense_PFA
      t.decimal :expense_UFA
      t.decimal :expense_billing
      t.integer :project_id
    end
  end
end
