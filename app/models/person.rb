class Person < ActiveRecord::Base
  validates_uniqueness_of :employee_number
  validates_numericality_of :charge_rate

  has_many :clients
  has_many :personalcharges
  has_many :billings
  has_one  :user
  has_many :bookings
  has_many :projects, :through => :bookings
  has_many  :expenses

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

  named_scope :workings, :conditions =>"dicts.title <> 'Resigned' and dicts.category = 'person_status' ", :include=>:status,:order =>"english_name"

  def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end

  def self.my_teams(current_user)
    projects = Project.find(:all)
    my_bookings = []
    projects.each{|project| my_bookings<< project.bookings if project.is_booking?(current_user.person_id) }
    my_bookings =   Hash[*my_bookings.map {|obj| [obj.person_id, obj]}.flatten].values

    ids=""
    my_bookings.each{|booking| ids += (booking.person_id.to_s+",")} 
    ids += " 0 "

    teams = self.find(:all, :conditions=> "id in (#{ids})", :order => "english_name")

    case current_user.roles
      when "providence_breaker":
        teams = self.find(:all, :order => "english_name")
      when "partner":
        teams = self.find(:all, :conditions=> "id in (#{ids})", :order => "english_name")
      when "manager":
        teams = self.find(:all, :conditions=> "id in (#{ids})", :order => "english_name")     
      when "employee":
        teams = self.find(:all, :conditions => "id = #{current_user.person_id}")
    else
        teams = self.find(:all, :order => "english_name")
    end
    
    return teams
  end

  def my_projects(sql="1",order_str="projects.created_on")
    myprojects = Project.my_projects(sql,order_str,self)
  end

  def my_bookings
    mybookings = Booking.find(:all,:conditions=>["person_id=?",self.id], :select=>"distinct project_id,job_code, state, person_id", :joins=>" left join projects on projects.id = bookings.project_id")
    myprojects=[]
    for mybooking in mybookings
      myprojects << mybooking.project if mybooking.state == "approved"
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
