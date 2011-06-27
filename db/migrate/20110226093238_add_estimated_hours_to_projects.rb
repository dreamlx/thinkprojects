class AddEstimatedHoursToProjects < ActiveRecord::Migration
  def self.up
	add_column :projects, :estimated_hours, :integer, :default=>0
  end

  def self.down
  	remove_column :projects, :estimated_hours
	end
end
