class AddColumnIncludingOThours < ActiveRecord::Migration
  def self.up
    add_column :personalcharges, :ot_hours, :decimal, :default=>0
  end

  def self.down
  end
end
