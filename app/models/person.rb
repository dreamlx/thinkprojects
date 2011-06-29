class Person < ActiveRecord::Base
  validates_uniqueness_of :employee_number
  validates_numericality_of :charge_rate

  has_many :projects, :foreign_key=>:manager_id
  has_many :clients
  has_many :personalcharges
  has_many :billings
  has_one  :user
  has_many :bookings

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
    role = current_user.roles
    teams=[]
    iam=self.find(:first, :conditions=>["id=?",current_user.person_id])
    teams << iam
    case role
    when "employee"
      
    when "manager"
      #iam.projects.each{|project|
      #  project.bookings.each{|booking| teams<< booking.person}
      #}
    else
      teams = self.find(:all)
      
    end
    teams=   Hash[*teams.map {|obj| [obj.english_name, obj]}.flatten].values

    tms = teams.sort_by{|t| t.english_name}
    return tms
  end
end
