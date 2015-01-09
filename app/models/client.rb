class Client < ActiveRecord::Base
  belongs_to  :industry
  # belongs_to  :category, :class_name => "Dict",  :foreign_key => "category_id",  :conditions => "category ='client_category'"
  belongs_to  :category,  -> { where category:'client_category' }, :class_name => "Dict",  :foreign_key => "category_id"
  # belongs_to  :status,   :class_name => "Dict",  :foreign_key => "status_id",    :conditions => "category ='client_status'"
  belongs_to  :status,    -> { where category:'client_status' },   :class_name => "Dict",  :foreign_key => "status_id"
  # belongs_to  :region,   :class_name => "Dict",  :foreign_key => "region_id",    :conditions => "category ='region'"
  belongs_to  :region,    -> { where category:'region' },          :class_name => "Dict",  :foreign_key => "region_id"
  belongs_to  :user
  has_many    :projects
  has_many    :contacts
  validates   :client_code, uniqueness: {on: :create, message: "is already being used"}

  accepts_nested_attributes_for :contacts, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  def self.selected_clients
    order("english_name").map {|c| ["#{c.client_code} || #{c.english_name}", c.id ] }
  end
end
