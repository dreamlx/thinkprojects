class RemoveColumnFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :billing_partner_id
    remove_column :projects, :billing_manager_id
    remove_column :projects, :referring_id
    remove_column :projects, :partner_id
    remove_column :projects, :manager_id
  end

  def self.down

  end
end