class RemoveStrictFromPrjExpenceLogs < ActiveRecord::Migration
  def up
    change_column :prj_expense_logs, :other, :string, :null => true
  end

  def down
    change_column :prj_expense_logs, :other, :string, :null => false
  end
end
