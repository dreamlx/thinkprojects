class Contact < ActiveRecord::Base
  belongs_to :client
  # attr_accessible :client_id, :name, :title, :gender, :other, :mobile, :tel, :fax, :email,
                  # :address, :city, :state, :country, :postalcode
end