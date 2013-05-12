class AddApprovedByToPerson < ActiveRecord::Migration
  def self.up
  	add_column :expenses, :approved_by, :integer
  end

  def self.down
  end
end
