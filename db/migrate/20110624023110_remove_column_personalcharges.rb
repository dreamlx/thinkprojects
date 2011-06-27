class RemoveColumnPersonalcharges < ActiveRecord::Migration
  def self.up
    remove_column :personalcharges, :reimbursement
    remove_column :personalcharges, :meal_allowance
    remove_column :personalcharges, :travel_allowance
  end

  def self.down
  end
end
