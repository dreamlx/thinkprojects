class Client < ActiveRecord::Base
  belongs_to  :industry
  belongs_to  :category, :class_name => "Dict",  :foreign_key => "category_id",  :conditions => "category ='client_category'"
  belongs_to  :status,   :class_name => "Dict",  :foreign_key => "status_id",    :conditions => "category ='client_status'"
  belongs_to  :region,   :class_name => "Dict",  :foreign_key => "region_id",    :conditions => "category ='region'"
  belongs_to  :user
  has_many    :projects
  has_many    :contacts
  validates   :client_code, uniqueness: {on: :create, message: "is already being used"}

  accepts_nested_attributes_for :contacts, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessible :client_code, :chinese_name, :english_name, :user_id, 
                  :industry_id, :category_id, :status_id, :region_id, :contacts_attributes,
                  :id, :person_id, :address_1, :person1, :person2, :address_2, :city_1, 
                  :city_2, :state_1, :state_2, :country_1, :country_2, :postalcode_1, :postalcode_2, 
                  :title_1, :title_2, :gender1_id, :gender2_id, :mobile_1, :mobile_2, :tel_1, :tel_2, 
                  :fax_1, :fax_2, :email_1, :email_2, :description, :person3, :title_3, :gender3_id, 
                  :mobile_3, :tel_3, :fax_3, :email_3, :created_on, :updated_on

  def self.selected_clients
    order("english_name").map {|c| ["#{c.client_code} || #{c.english_name}", c.id ] }
  end
end
