class Personalcharge < ActiveRecord::Base
  acts_as_commentable

  validates :hours, numericality: true
  validates :ot_hours, numericality: true
  belongs_to :project
  belongs_to :period 
  belongs_to :user
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

  attr_accessible :user_id, :period_id, :charge_date, :hours, :ot_hours, :desc, :project_id
  def self.sum_by_sql(sql)
    sum_p = self.new
    sum_p.hours = self.sum(:hours,:conditions=>sql,:include=>:period)
    sum_p.service_fee = self.sum(:service_fee,:conditions=>sql,:include=>:period)

    return sum_p
  end

  def self.my_personalcharges(current_user,sql)
    #思考角色判断-todo
    projects = Project.my_projects(current_user)

    prj_ids = ""
    projects.each{|p| prj_ids += " #{p.id}," }
    prj_ids += "0"

    case 
    when current_user.roles == "providence_breaker"

    when current_user.roles == "partner"
      sql += " and project_id in (#{prj_ids})"
    when current_user.roles == "manager"
      sql += " and (user_id = #{current_user.id})"
    when current_user.roles == "senior"
      sql += " and (user_id = #{current_user.id})"        
    when current_user.roles == "staff"
      sql += " and (user_id = #{current_user.id})"
    else
    end

    self.where(:conditions=> sql,
    :joins=>" left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id left join users on personalcharges.user_id = users.id",
    :order=>" personalcharges.charge_date desc,personalcharges.created_on desc,users.english_name, periods.number,  projects.job_code, personalcharges.hours,personalcharges.state desc ")

  end

  def ot_pay_hours
        sql_ot =session[:personalcharge_ot] 
        approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
        OverTime.ot_pay_hours(approved_personalcharges)
  end

  def employee
      if self.person
        self.person.english_name.humanize 
      else
        ""
      end
  end

  def period_number
      if self.period
        self.period.number
      else
        ""
      end        
  end

  def job_code
      if self.project
        self.project.job_code
      else
        ""
      end    
  end
end
