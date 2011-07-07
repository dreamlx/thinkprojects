class AddColumnToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :billable, :boolean, :default=>true
    change_column :projects, :state, :string, :null=>false, :default=> 'pending'
    change_column :personalcharges, :state, :string, :null=>false, :defalut =>"pending"
  end

  def self.down
  end
end
