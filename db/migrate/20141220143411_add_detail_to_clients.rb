class AddDetailToClients < ActiveRecord::Migration
  def change
    add_column :clients, :person_id, :integer
    add_column :clients, :address_1, :string
    add_column :clients, :person1, :string
    add_column :clients, :person2, :string
    add_column :clients, :address_2, :string
    add_column :clients, :city_1, :string
    add_column :clients, :city_2, :string
    add_column :clients, :state_1, :string
    add_column :clients, :state_2, :string
    add_column :clients, :country_1, :string
    add_column :clients, :country_2, :string
    add_column :clients, :postalcode_1, :string
    add_column :clients, :postalcode_2, :string
    add_column :clients, :title_1, :string
    add_column :clients, :title_2, :string
    add_column :clients, :gender1_id, :string
    add_column :clients, :gender2_id, :string
    add_column :clients, :mobile_1, :string
    add_column :clients, :mobile_2, :string
    add_column :clients, :tel_1, :string
    add_column :clients, :tel_2, :string
    add_column :clients, :fax_1, :string
    add_column :clients, :fax_2, :string
    add_column :clients, :email_1, :string
    add_column :clients, :email_2, :string
    add_column :clients, :person3, :string
    add_column :clients, :title_3, :string
    add_column :clients, :gender3_id, :string
    add_column :clients, :mobile_3, :string
    add_column :clients, :tel_3, :string
    add_column :clients, :fax_3, :string
    add_column :clients, :email_3, :string
  end
end
