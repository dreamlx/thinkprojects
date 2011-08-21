class RemoveProjectStatus < ActiveRecord::Migration
  def self.up
    remove_column :projects, :status_id
  end

  def self.down
  end
end
