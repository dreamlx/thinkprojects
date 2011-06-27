class AddTextToPersonalcharges < ActiveRecord::Migration
  def self.up
  add_column :personalcharges,:desc, :text
	end

  def self.down
	remove_column :personalcharges,:desc
  end
end
