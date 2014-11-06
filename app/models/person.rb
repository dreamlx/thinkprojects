class Person < ActiveRecord::Base
  validates_uniqueness_of :employee_number
  validates_numericality_of :charge_rate

  has_many :clients
  has_many :personalcharges
  has_many :billings
  has_one  :user
  has_many :bookings
  has_many :projects, :through => :bookings
  has_many :expenses

  attr_accessible :chinese_name, :english_name, :employee_number, :charge_rate, :employment_date, :address, :postalcode, :mobile, :tel, :position, :gender, :department_id, :status_id, :department, :status

  has_many :manager_projects, :class_name=> "Project", :foreign_key => :manager_id

  

  def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end

  def my_projects
    myprojects = Project.my_projects
  end
  
  def my_personalcharges(sql="1")
    Personalcharge.my_personalcharges(self.id,sql)
  end
end
