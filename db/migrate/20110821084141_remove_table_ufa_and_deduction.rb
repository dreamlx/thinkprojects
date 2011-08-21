class RemoveTableUfaAndDeduction < ActiveRecord::Migration
  def self.up
    	begin	drop_table "ufafees" rescue true end
	begin	drop_table "deductions" rescue true end
  end

  def self.down
  end
end
