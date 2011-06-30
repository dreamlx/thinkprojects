class AddWorkHoursToPeriod < ActiveRecord::Migration
  def self.up
	add_column :periods, :work_hours, :integer, :default=>0  
end

  def self.down
  end
end
