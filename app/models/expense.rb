class Expense < ActiveRecord::Base
  acts_as_commentable
  validates_presence_of :charge_date
  validates_presence_of :person_id
  validates_presence_of :type
  validates_numericality_of :fee

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

  def self.paginate_by_sql(search,page = 1, order_str = " created_at ")
    paginate :per_page => 20, :page => page,
      :conditions=>search,
      :joins=>" left join projects on project_id = projects.id left join clients on client_id = clients.id",
      :order=>order_str
  end

  def self.my_expenses(current_user,sql="1", order_str="expenses.charge_date desc,expenses.state desc")
    
    case current_user.roles
      when "providence_breaker":

      when "partner":
        projects = Project.my_projects(current_user)

        prj_ids = ""
        projects.each{|p| prj_ids += " #{p.id}," }
        prj_ids += "0"
        sql += " and project_id in (#{prj_ids})" #和自己项目有关
      when "manager":
        sql += " and (expenses.person_id = #{current_user.person_id})"
      when "senior":
        sql += " and (expenses.person_id = #{current_user.person_id})"        
      when "staff":
        sql += " and (expenses.person_id = #{current_user.person_id})"
    else
    end
    
    self.find(:all, :conditions=> sql,
      :joins=>" left join projects on project_id = projects.id left join clients on client_id = clients.id",
      :order=>order_str)
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
        Person.find(self.approved_by).english_name

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
