class DropHoursFromPeriod < ActiveRecord::Migration
  def self.up
 remove_column :periods, :hours  
end

  def self.down
  end
end
