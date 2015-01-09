class AddDetailToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :status_id, :integer
    add_column :projects, :partner_id, :integer
    add_column :projects, :referring_id, :integer
    add_column :projects, :billing_partner_id, :integer
    add_column :projects, :billing_manager_id, :integer
    change_column :projects, :contract_number, :string, :null => true
    change_column :projects, :job_code, :string, :null => true
  end

  def down
    remove_column :projects, :status_id, :integer
    remove_column :projects, :partner_id, :integer
    remove_column :projects, :referring_id, :integer
    remove_column :projects, :billing_partner_id, :integer
    remove_column :projects, :billing_manager_id, :integer
    change_column :projects, :contract_number, :string, :null => false
    change_column :projects, :job_code, :string, :null => false
  end
end
