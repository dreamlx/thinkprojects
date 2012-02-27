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


  validates_uniqueness_of :client_code,
                          :on =>:create,
                          :message => "is already being used"
end
