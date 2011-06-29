class AddApprovalToProjects < ActiveRecord::Migration
  def self.up
  add_column :projects, :approval, :boolean
	end

  def self.down
	remove_column :projects, :approval
  end
end
