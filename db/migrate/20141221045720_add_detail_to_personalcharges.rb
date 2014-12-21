class AddDetailToPersonalcharges < ActiveRecord::Migration
  def change
    add_column :personalcharges, :reimbursement, :decimal
    add_column :personalcharges, :meal_allowance, :decimal
    add_column :personalcharges, :travel_allowance, :decimal
    add_column :personalcharges, :person_id, :integer
  end
end
