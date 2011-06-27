class Project < ActiveRecord::Base
  # human names
  validates_uniqueness_of          :job_code
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
  has_many :expeases,         :dependent => :destroy
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


  def self.search_by_sql(search,page = 1, order_str = "job_code")

    paginate :per_page => 20, :page => page,
      :conditions=>search,
      :include =>[:status,:client],
      :order=>order_str
  end

  def self.search(page)
    paginate :per_page => 10, :page => page,
      :order => 'created_on desc'
  end

  def self. my_bookings(current_user)
    mybookings = Booking.find(:all,:conditions=>["person_id=?",current_user.person_id])
    myprojects=[]

    role = current_user.roles||""
    case role
    when "providence_breaker":
        myprojects = self.find(:all, :conditions=>"state='approved'")
    else   
      for mybooking in mybookings
        myproject = mybooking.project
        myprojects << myproject if myproject.state =="approved"
      end
    end
    prjs =myprojects.sort_by{|p| p.job_code}
    return prjs
  end
  
  def self.my_projects(current_user=nil)
    role = current_user.roles||""

    case role
    when "employee":
        myprojects = self.my_bookings(current_user)
    when "manager":
        bookprojects = self.my_bookings(current_user)
      ownerprojects =self.find(:all, :include =>:status, :conditions=>["manager_id=? and state =?",current_user.person_id,"approved"])
      myprojects =[]
      myprojects = ownerprojects

      bookprojects.each{|book| myprojects << book unless myprojects.include?(book)}

    when "director":
        myprojects = self.find(:all, :include =>:status, :conditions=>["state =?","approved"])
    else
      myprojects = self.find(:all)
    end


    return myprojects.compact
  end

end
