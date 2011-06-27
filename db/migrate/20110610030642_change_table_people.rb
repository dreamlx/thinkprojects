class ChangeTablePeople < ActiveRecord::Migration
  def self.up
    rename_column :people, :employeement_date, :employment_date
    rename_column :people, :gender_id, :gender
    change_column :people, :gender, :string
    remove_column :people, :role_id
  end

  def self.down
  end
end
