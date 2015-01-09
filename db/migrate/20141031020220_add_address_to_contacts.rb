class AddAddressToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :address, :text
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :country, :string
    add_column :contacts, :postalcode, :string
  end
end
