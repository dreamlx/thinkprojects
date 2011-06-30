class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :expense_category
      t.decimal :fee
      t.integer :project_id
      t.date :charge_date
      t.string :state
      t.string :desc, :default => ''
      t.integer :period_id
      t.timestamps
    end
   
  end

  def self.down
  end
end
