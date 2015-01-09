class Project < ActiveRecord::Base
  acts_as_commentable
  # validates :job_code, uniqueness: true
  # validates :manager_id, presence: true
  # validates :client_id, presence: true
  # validates :estimated_hours, numericality: true
  # validates :estimated_annual_fee, numericality: true
  # validates :budgeted_expense, numericality: true
  # validates :budgeted_service_fee, numericality: true

  has_many :billings,         :dependent => :destroy
  has_many :expenses,         :dependent => :destroy
  has_many :personalcharges,  :dependent => :destroy
  has_many :bookings,         :dependent => :destroy
  has_many :users,            through: :bookings
  
  belongs_to :client
  # belongs_to :GMU,          :class_name => "Dict",    :foreign_key => "GMU_id",         :conditions => "category ='GMU'"
  belongs_to :GMU,          -> { where category: 'GMU' },            class_name: "Dict", foreign_key: "GMU_id"
  # belongs_to :service_code, :class_name => "Dict",    :foreign_key => "service_id",     :conditions => "category = 'service_code'"
  belongs_to :service_code, -> { where category:'service_code' }, :class_name => "Dict",    :foreign_key => "service_id"
  # belongs_to :PFA_reason,   :class_name => "Dict",    :foreign_key => "PFA_reason_id",  :conditions => "category = 'PFA_reason'"
  belongs_to :PFA_reason,   -> { where category:'PFA_reason' },   :class_name => "Dict",    :foreign_key => "PFA_reason_id"
  # belongs_to :revenue,      :class_name => "Dict",    :foreign_key => "revenue_id",     :conditions => "category = 'revenue_type'"
  belongs_to :revenue,      -> { where category:'revenue_type' }, :class_name => "Dict",    :foreign_key => "revenue_id"
  # belongs_to :risk,         :class_name => "Dict",    :foreign_key => "risk_id",        :conditions => "category = 'risk'"
  belongs_to :risk,         -> { where category:'risk'},          :class_name => "Dict",    :foreign_key => "risk_id"
  belongs_to :manager,      :class_name => "User",    :foreign_key => "manager_id"

  scope :alive, -> { where(state: 'approved').order("job_code") }
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
end
