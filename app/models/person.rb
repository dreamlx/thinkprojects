class Person < ActiveRecord::Base
  validates_uniqueness_of :employee_number
  validates_numericality_of :charge_rate

  has_many :clients
  has_many :personalcharges
  has_many :billings
  has_one  :user
  has_many :bookings
  has_many  :expenses

  has_many :partner_projects,
    :class_name=> "Project",
    :foreign_key => :partner_id

  has_many :manager_projects,
    :class_name=> "Project",
    :foreign_key => :manager_id

  belongs_to :GMU,
    :class_name => "Dict",
    :foreign_key => "GMU_id",
    :conditions => "category ='GMU'"
  
  belongs_to :status,
    :class_name => "Dict",
    :foreign_key => "status_id",
    :conditions => "category = 'person_status'"

  belongs_to :department,
    :class_name => "Dict",
    :foreign_key => "department_id",
    :conditions => "category = 'department'"


  def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end

  def self.my_teams(current_user)
    
    teams=[]
    ids=""
    iam=self.find(current_user.person_id)
    iam.manager_projects.each{|p|
      p.bookings.each{|b|
        ids+=(b.person_id.to_s+",")
      }
    }
    iam.partner_projects.each{|p|
      p.bookings.each{|b|
        ids+=(b.person_id.to_s+",")
      }
    }

    ids += current_user.person_id.to_s

    teams = self.find(:all, :conditions=> "id in (#{ids})")
    teams=   Hash[*teams.map {|obj| [obj.english_name, obj]}.flatten].values
    tms = teams.sort_by{|t| t.english_name}
    return tms
  end

  def my_projects(sql="1",order_str="projects.created_on")
    order_str = "projects.created_on" if order_str.blank?
    myprojects = Project.find(:all, :conditions=>sql, :order=> order_str, :include =>[:status,:client])
    all_projects=[]
    myprojects.each{|p|
      all_projects << p if p.is_partner?(self.id) or p.is_manager?(self.id) or p.is_booking?(self.id)
    }
    return all_projects.compact
  end

def my_bookings
    mybookings = Booking.find(:all,:conditions=>["person_id=?",self.id], :select=>"distinct project_id")
    myprojects=[]
    for mybooking in mybookings
      myprojects << mybooking.project if mybooking.project.state =="approved"
    end

    prjs =myprojects.sort_by{|p| p.job_code}
    return prjs
  end
  
  def my_personalcharges(sql="1")
    Personalcharge.my_personalcharges(self.id,sql)
  end

  def my_expenses(sql="1")
    Expense.my_expenses(self.id,sql)
  end
  
end
