class AddPersonIdToBillings < ActiveRecord::Migration
  def change
    add_column :billings, :person_id, :integer
    change_column :billings, :status, :string, :null => true
  end
end
