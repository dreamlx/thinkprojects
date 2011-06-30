class AddStateToProjects < ActiveRecord::Migration
  def self.up
  	add_column :projects, :state, :string
	remove_column :projects, :approval
  end

  def self.down
  end
end
