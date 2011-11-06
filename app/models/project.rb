class Project < ActiveRecord::Base
  # human names
  acts_as_commentable
  validates_uniqueness_of           :job_code
  validates_presence_of             :manager_id,:message => "Please select one person as project creator "
  validates_numericality_of         :estimated_hours
  validates_numericality_of         :estimated_annual_fee
  validates_numericality_of         :budgeted_expense
  validates_numericality_of         :budgeted_service_fee
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
  


  has_many :billings,         :dependent => :destroy
  has_many :expenses,         :dependent => :destroy
  has_many :personalcharges,  :dependent => :destroy
  has_many :bookings,         :dependent => :destroy
  has_many :members,          :through => :bookings, :source => :person
  
  belongs_to :client
  
  belongs_to :GMU, 
    :class_name => "Dict",
    :foreign_key => "GMU_id",
    :conditions => "category ='GMU'"

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
  
  belongs_to :manager,
    :class_name => "Person",
    :foreign_key => "manager_id"



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

  def self.my_bookings(person_id)
    Person.find(person_id).my_bookings
  end
  
  def is_booking?(id)
    flag = false
    #bug#self.bookings.each{|b| flag =true if b.person_id == id} 
    return flag
  end

  def is_manager?(id)
    self.manager_id == id ? true : false
  end
  
  def self.my_projects(current_user,sql="1",order_str="projects.created_on") 
    if current_user.roles == 'providence_breaker' or current_user.roles == "parnter"
      #all projects
      projects = Project.find(:all, :conditions=>sql, :order=> order_str, :include=>[:client, :bookings] )
    else
      # the booking projects including me
      sql += " and bookings.person_id = #{current_user.person_id}"
      projects = Project.find(:all, :conditions=>sql, :order=> order_str, :include=>[:client, :bookings] )
    end
    return projects   
  end
  
end
