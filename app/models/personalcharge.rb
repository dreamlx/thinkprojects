class Personalcharge < ActiveRecord::Base
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
  
  def self.my_personalcharges(person_id,sql)
    sql += " and (projects.partner_id = #{person_id} or projects.manager_id = #{person_id} or person_id = #{person_id})"
    self.find(:all, :conditions=> sql,  :joins=>"left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id",
      :order=>"personalcharges.state desc")
  end

  def self.my_group_hours(person_id,condition)
    condition += " and (projects.partner_id = #{person_id} or projects.manager_id = #{person_id} or person_id = #{person_id})"
    sql = "select sum(hours) as hours,person_id,charge_date from personalcharges left join projects on personalcharges.project_id = projects.id left join periods on personalcharges.period_id = periods.id where "
    sql += condition
    sql += " group by personalcharges.person_id, charge_date "
    sql += "having charge_date is not null"
    items = self.find_by_sql(sql)
    return items
  end

  def self.standard_hours(person_id,sql)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.my_group_hours(person_id,sql)
    items.each{|i|
      if otsetup["working_days"].include?(i.charge_date.to_date.wday) #current day is work day?

        hours += otsetup["daily_working_hours"]
      end

    }
    return hours
  end

  def self.ot_hours(person_id,sql)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.my_group_hours(person_id,sql)
    items.each{|i|
      if otsetup["working_days"].include?(i.charge_date.to_date.wday) #current day is work day?
        if i.hours - otsetup["daily_working_hours"] >0
          hours += (i.hours - otsetup["daily_working_hours"] )
        end
      else
        hours += i.hours
      end
    }
    return hours
  end

  def self.ot_pay_hours(person_id,sql)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.my_group_hours(person_id,sql)
    items.each{|i|
      if otsetup["working_days"].include?(i.charge_date.to_date.wday) #current day is work day?
        if i.hours - otsetup["daily_working_hours"] >0
          hours += ((i.hours - otsetup["daily_working_hours"] )/2)
        end
      else
        hours += i.hours
      end
    }
    return hours
  end

  def self.iam_partner(person_id,sql="1")
    sql += " and projects.partner_id = #{person_id}"
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
