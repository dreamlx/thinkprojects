class RemoveTables < ActiveRecord::Migration
  def self.up
	begin	drop_table "users" rescue true end
	begin	drop_table "overtimes" rescue true end
	begin	drop_table "privileges" rescue true end
	begin	drop_table "privileges_roles" rescue true end
	begin	drop_table "roles" rescue true end
	begin	drop_table "sumselects" rescue true end
	begin	drop_table "limit_fees" rescue true end
	begin	drop_table "outsourcings" rescue true end
	begin	drop_table "commissions" rescue true end

  end

  def self.down
  end
end
