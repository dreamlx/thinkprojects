class Project < ActiveRecord::Base
  acts_as_commentable
  validates :job_code, uniqueness: true
  validates :manager_id, presence: true
  validates :client_id, presence: true
  validates :estimated_hours, numericality: true
  validates :estimated_annual_fee, numericality: true
  validates :budgeted_expense, numericality: true
  validates :budgeted_service_fee, numericality: true
  
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

  def self.my_projects(user)
    Project.all
  end
end
