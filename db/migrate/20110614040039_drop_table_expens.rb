class DropTableExpens < ActiveRecord::Migration
  def self.up
    begin	drop_table "expenses" rescue true end
     begin	drop_table "expensetypes" rescue true end
      begin	drop_table "expense_items" rescue true end
  end

  def self.down
  end
end
