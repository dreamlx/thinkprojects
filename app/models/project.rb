class Project < ActiveRecord::Base
  acts_as_commentable
  validates_uniqueness_of           :job_code
  validates_presence_of             :manager_id,:message => "Please select one person as project creator "
  validates_presence_of             :client_id
  validates_numericality_of         :estimated_hours
  validates_numericality_of         :estimated_annual_fee
  validates_numericality_of         :budgeted_expense
  validates_numericality_of         :budgeted_service_fee
  
  attr_accessible :job_code, :state, :client_id, :manager_id,
                  :GMU_id, :description, :service_id, :starting_date, :ending_date, 
                  :estimated_annual_fee, :estimated_hours, :budgeted_service_fee, :budgeted_expense

  has_many :billings,         :dependent => :destroy
  has_many :expenses,         :dependent => :destroy
  has_many :personalcharges,  :dependent => :destroy
  has_many :bookings,         :dependent => :destroy
  has_many :members,          :through => :bookings, :source => :person
  
  belongs_to :client
  belongs_to :GMU,          :class_name => "Dict",    :foreign_key => "GMU_id",         :conditions => "category ='GMU'"
  belongs_to :service_code, :class_name => "Dict",    :foreign_key => "service_id",     :conditions => "category = 'service_code'"
  belongs_to :PFA_reason,   :class_name => "Dict",    :foreign_key => "PFA_reason_id",  :conditions => "category = 'PFA_reason'"
  belongs_to :revenue,      :class_name => "Dict",    :foreign_key => "revenue_id",     :conditions => "category = 'revenue_type'"
  belongs_to :risk,         :class_name => "Dict",    :foreign_key => "risk_id",        :conditions => "category = 'risk'"
  belongs_to :manager,      :class_name => "User",    :foreign_key => "manager_id"

  scope :alive, :conditions =>"state = 'approved'", :order=>'job_code'
  
  state_machine :initial => :pending do
    event :approval do
      transition all =>:approved
    end
    event :disapproval do
      transition all => :disapproved
    end
    event :close do
      transition all => :closed
    end
    event :transform do
      transition :approval => :transformed
    end
    event :reset do
      transition all => :pending
    end
  end

  def name
    job_code
  end

  def self.my_bookings(user_id)
    User.find(user_id).my_bookings
  end
  
  def is_booking?(id)
    flag = false
    #bug#self.bookings.each{|b| flag =true if b.person_id == id} 
    return flag
  end

  def is_manager?(id)
    self.manager_id == id ? true : false
  end
  
  def self.my_projects(user)
    if user.roles == 'providence_breaker' 
      projects = Project.all
    else
      projects = Project.include(:client, :bookings).where(user_id: user.id).order(:created_on)
    end 
  end
end
