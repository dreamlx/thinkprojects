class Contact < ActiveRecord::Base
  belongs_to :client
  attr_accessible :client_id, :name, :title, :gender, 
                  :mobile, :tel, :fax, :email,
                  :address, :city, :state, :country, :postalcode, :other
end
