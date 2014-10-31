class Client < ActiveRecord::Base

  belongs_to :industry
  has_many :projects

  belongs_to :category,
  :class_name => "Dict",
  :foreign_key => "category_id",
  :conditions => "category ='client_category'"

   belongs_to :status,
  :class_name => "Dict",
  :foreign_key => "status_id",
  :conditions => "category ='client_status'"

  belongs_to :region,
  :class_name => "Dict",
  :foreign_key => "region_id",
  :conditions => "category ='region'"


  belongs_to :gender1,
  :class_name => "Dict",
  :foreign_key => "gender1_id",
  :conditions => "category = 'gender'"

  belongs_to :gender2,
  :class_name => "Dict",
  :foreign_key => "gender2_id",
  :conditions => "category = 'gender'"

  belongs_to :gender3,
  :class_name => "Dict",
  :foreign_key => "gender3_id",
  :conditions => "category = 'gender'"

  belongs_to :person
  attr_accessible :client_code, :chinese_name, :english_name, :person_id, 
                  :person1, :title_1, :mobile_1, :tel_1, :fax_1, :email_1, :gender1_id, :address_1, :city_1, :state_1, :country_1, :postalcode_1, 
                  :person2, :title_2, :mobile_2, :tel_2, :fax_2, :email_2, :gender2_id, :address_2, :city_2, :state_2, :country_2, :postalcode_2, 
                  :person3, :title_3, :mobile_3, :tel_3, :fax_3, :email_3, :gender3_id, 
                  :industry, :category_id, :status_id, :region_id

  validates_uniqueness_of :client_code,
                          :on =>:create,
                          :message => "is already being used"
end
