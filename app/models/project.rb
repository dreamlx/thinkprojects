class Project < ActiveRecord::Base
  # human names
  validates_uniqueness_of          :job_code
  validates_presence_of :partner_id
  validates_presence_of :manager_id
  validates_numericality_of       :estimated_hours
  validates_numericality_of       :estimated_annual_fee
  validates_numericality_of       :budgeted_expense
  validates_numericality_of       :budgeted_service_fee
  ModelName = "Project"
  ColumnNames ={
    :contract_number => "contract_number",
    :job_code => "job_code",
    :description => "description",
    :starting_date => "starting_date",
    :ending_date => "ending_date",
    :estimated_annual_fee => "estimated_annual_fee",
    :contracted_service_fee => "contracted_service_fee",
    :estimated_commision => "estimated_commision",
    :estimated_outsorcing => "estimated_outsorcing",
    :budgeted_service_fee => "budgeted_service_fee",
    :service_PFA => "service_PFA",
    :expense_PFA => "expense_PFA",
    :contracted_expense => "contracted_expense",
    :budgeted_expense => "budgeted_expense",
    :client_name =>"client name"
  }
  
  has_one :deduction

  has_many :billings,         :dependent => :destroy
  has_many :expenses,         :dependent => :destroy
  has_many :personalcharges, :dependent => :destroy
  has_many :ufafees,          :dependent => :destroy
  has_many :bookings,         :dependent => :destroy
  
  belongs_to :client
  
  belongs_to :GMU, 
    :class_name => "Dict",
    :foreign_key => "GMU_id",
    :conditions => "category ='GMU'"
  
  belongs_to :status,
    :class_name => "Dict",
    :foreign_key => "status_id",
    :conditions => "category = 'prj_status'"
  
  belongs_to :service_code,
    :class_name => "Dict",
    :foreign_key => "service_id",
    :conditions => "category = 'service_code'"

  belongs_to :PFA_reason,
    :class_name => "Dict",
    :foreign_key => "PFA_reason_id",
    :conditions => "category = 'PFA_reason'"
    
  belongs_to :revenue,
    :class_name => "Dict",
    :foreign_key => "revenue_id",
    :conditions => "category = 'revenue_type'"
  
  belongs_to :risk,
    :class_name => "Dict",
    :foreign_key => "risk_id",
    :conditions => "category = 'risk'"
  
  belongs_to :partner,
    :class_name => "Person",
    :foreign_key => "partner_id"
  
  belongs_to :manager,
    :class_name => "Person",
    :foreign_key => "manager_id"
  
  belongs_to :referring,
    :class_name => "Person",
    :foreign_key => "referring_id"

  belongs_to :billing_partner,
    :class_name => "Person",
    :foreign_key => "billing_partner_id"
  
  belongs_to :billing_manager,
    :class_name => "Person",
    :foreign_key => "billing_manager_id"


  named_scope :alive, :conditions =>"state = 'approved'", :order=>'job_code'

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


  def self. my_bookings(current_user)
    mybookings = Booking.find(:all,:conditions=>["person_id=?",current_user.person_id], :select=>"distinct project_id")
    myprojects=[]
    for mybooking in mybookings
      myprojects << mybooking.project if mybooking.project.state =="approved"
    end

    prjs =myprojects.sort_by{|p| p.job_code}
    return prjs
  end
  


  def is_booking?(id)
    flag = false
    self.bookings.each{|b| flag =true if b.person_id == id}
    return flag
  end

  def is_partner?(id)
    self.partner_id == id ? true : false
  end

  def is_manager?(id)
    self.manager_id == id ? true : false
  end
  
end
