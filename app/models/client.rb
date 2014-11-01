class Client < ActiveRecord::Base
  belongs_to  :industry
  belongs_to  :category, :class_name => "Dict",  :foreign_key => "category_id",  :conditions => "category ='client_category'"
  belongs_to  :status,   :class_name => "Dict",  :foreign_key => "status_id",    :conditions => "category ='client_status'"
  belongs_to  :region,   :class_name => "Dict",  :foreign_key => "region_id",    :conditions => "category ='region'"
  belongs_to  :person
  has_many    :projects
  has_many    :contacts
  validates   :client_code, uniqueness: {on: :create, message: "is already being used"}

  accepts_nested_attributes_for :contacts, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessible :client_code, :chinese_name, :english_name, :person_id, 
                  :industry_id, :category_id, :status_id, :region_id, :contacts_attributes
end
