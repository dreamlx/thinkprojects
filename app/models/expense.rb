class Expense < ActiveRecord::Base
  acts_as_commentable
  validates :charge_date, :user_id, presence: true
  validates :fee, numericality: true

  belongs_to :project
  belongs_to :period
  belongs_to :user

  attr_accessible :charge_date, :approved_by, :billable, :expense_category, :fee, :desc, :person_id, :project_id, :user_id
  
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

  def self.my_expenses(current_user,sql="1", order_str="expenses.charge_date desc,expenses.state desc") 
    case 
      when current_user.roles == "providence_breaker"
      when current_user.roles == "partner"
        projects = Project.my_projects(current_user)
        prj_ids = ""
        projects.each{|p| prj_ids += " #{p.id}," }
        prj_ids += "0"
        sql += " and project_id in (#{prj_ids})" #和自己项目有关
      when current_user.roles == "manager"
        sql += " and (expenses.person_id = #{current_user.person_id})"
      when current_user.roles == "senior"
        sql += " and (expenses.person_id = #{current_user.person_id})"        
      when current_user.roles == "staff"
        sql += " and (expenses.person_id = #{current_user.person_id})"
    else
    end
    
    self.joins(" left join projects on project_id = projects.id left join clients on client_id = clients.id").where(sql).order(order_str)
  end

  def employee
      if self.person
        self.person.english_name.humanize 
      else
        ""
      end
  end

  def approved_name
      if self.approved_by
        User.find(self.approved_by).english_name

      else
        ""
      end
  end  

  def client_name
      if self.project and self.project.client
        self.project.client.english_name
      else
        ""
      end        
  end

  def project_code
      if self.project
        self.project.job_code
      else
        ""
      end    
  end
end
