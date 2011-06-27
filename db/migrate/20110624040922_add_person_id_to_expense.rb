class AddPersonIdToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :person_id, :integer
  end

  def self.down
  end
end
