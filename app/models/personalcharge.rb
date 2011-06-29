class Personalcharge < ActiveRecord::Base

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
  
  def self.search_by_sql(search,page,current_user=nil)
    role = current_user.roles||""
    case role

    when "employee":
        search += " and person_id = #{current_user.person_id}" unless current_user.person_id.blank?
    when "manager":
        my_teams =  Person.my_teams(current_user) unless current_user.nil?
        
      team_ids=" "
      my_teams.each{|team|  team_ids = team_ids + team.id.to_s + ", " }
      search = search +" and person_id in(#{team_ids+"-1"})"
      #    myprojects = self.find(:all, :include =>:status, :conditions=>["manager_id=? and code ==?",current_user.person_id,1])
    when "director":
        #    myprojects = self.find(:all, :include =>:status, :conditions=>["code ==?",1])
    else
      #search
    end
    
    paginate :per_page => 10, :page => page,
      :conditions=>search,
      :include=>[:period,:project],
      :order => 'personalcharges.updated_on desc'
  end

  def self.sum_by_sql(sql)
    sum_p = self.new
    sum_p.hours = self.sum(:hours,:conditions=>sql,:include=>:period)
    sum_p.service_fee = self.sum(:service_fee,:conditions=>sql,:include=>:period)
    sum_p.reimbursement = self.sum(:reimbursement,:conditions=>sql,:include=>:period)
    sum_p.meal_allowance = self.sum(:meal_allowance,:conditions=>sql,:include=>:period)
    sum_p.travel_allowance = self.sum(:travel_allowance,:conditions=>sql,:include=>:period)
    return sum_p
  end
  
  def self.search(page)
    paginate :per_page => 10, :page => page,
      :order => 'created_on'
  end
end
