class AddColumnToPersonalcharge < ActiveRecord::Migration
  def self.up
    add_column :personalcharges, :charge_date, :date
  end

  def self.down
  end
end
