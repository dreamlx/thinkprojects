class Personalcharge < ActiveRecord::Base
  acts_as_commentable
  validates_presence_of :person_id
  validates_presence_of :charge_date

  validates_numericality_of :hours
  validates_numericality_of :ot_hours
  belongs_to :project
  belongs_to :period 
  belongs_to :person
  state_machine :initial => :pending do
    event :approval do
      transition all =>:approved
    end
    event :disapproval do
      transition all => :disapproved
    end
    event :reset do
      transition all => :pending
    end

  end
  


  def self.sum_by_sql(sql)
    sum_p = self.new
    sum_p.hours = self.sum(:hours,:conditions=>sql,:include=>:period)
    sum_p.service_fee = self.sum(:service_fee,:conditions=>sql,:include=>:period)

    return sum_p
  end
  
  def self.search(page)
    paginate :per_page => 10, :page => page,
      :order => 'created_on'
  end

  def self.group_hours(condition)
    sql = "select sum(hours) as hours,person_id,charge_date from personalcharges left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id where "
    sql += condition
    sql += " group by person_id, charge_date "
    sql += "having charge_date is not null"
    items = self.find_by_sql(sql)
    return items
  end
  
  def self.my_personalcharges(current_user,sql)
    #思考角色判断-todo
    projects = Project.my_projects(current_user)
    
    prj_ids = ""
    projects.each{|p| prj_ids += " #{p.id}," }
    prj_ids += "0"
    
    case current_user.roles
      when "providence_breaker":

      when "partner":
        sql += " and project_id in (#{prj_ids})"
      when "manager":
        sql += " and (person_id = #{current_user.person_id})"
      when "senior":
        sql += " and (person_id = #{current_user.person_id})"        
      when "staff":
        sql += " and (person_id = #{current_user.person_id})"
    else
    end
    
    self.find(:all, :conditions=> sql,  
      :joins=>" left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id left join people on personalcharges.person_id = people.id",
      :order=>" personalcharges.charge_date desc,personalcharges.created_on desc,people.english_name, periods.number,  projects.job_code, personalcharges.hours,personalcharges.state desc ")
        
  end

  def self.my_group_hours(person_id,condition)
    condition += " and ( projects.manager_id = #{person_id} or person_id = #{person_id})"
    sql = "select sum(hours) as hours,person_id,charge_date from personalcharges left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id where "
    sql += condition
    sql += " group by personalcharges.person_id, charge_date "
    sql += "having charge_date is not null"
    items = self.find_by_sql(sql)
    return items
  end

  
  def self.iam_partner(person_id,sql="1")
    #sql += " and projects.partner_id = #{person_id}"
    self.find(:all, :conditions =>sql,:include=>:project)
  end

  def self.iam_manager(person_id,sql="1")
    sql += " and projects.manager_id = #{person_id}"
    self.find(:all, :conditions =>sql,:include=>:project)
  end

  def self.iam_member(person_id)
    self.find(:all, :conditions =>" person_id = #{person_id}")
  end


end
