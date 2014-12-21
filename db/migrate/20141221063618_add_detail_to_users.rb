class AddDetailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hashed_password, :string
    add_column :users, :auth, :string
    add_column :users, :other1, :string
    add_column :users, :other2, :string
  end
end
