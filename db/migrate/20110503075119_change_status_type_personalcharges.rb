class ChangeStatusTypePersonalcharges < ActiveRecord::Migration
  def self.up
remove_column :personalcharges, :audit_flag
add_column    :personalcharges, :state, :string
end

  def self.down
  end
end
