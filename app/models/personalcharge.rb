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
  
  def self.paginate_by_sql(search,page)
    paginate :per_page => 10, :page => page,
      :conditions=>search,
      :include=>[:period,:project],
      :order => 'personalcharges.updated_on desc'
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
    sql = "select sum(hours) as hours,person_id,charge_date from personalcharges where "
    sql += condition
    sql += " group by person_id, charge_date "
    sql += "having charge_date is not null"
    items = self.find_by_sql(sql)
    return items
  end

  def self.standard_hours(condition)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.group_hours(condition)
    items.each{|i| hours += otsetup["daily_working_hours"].to_f}
    return hours
  end

  def self.ot_hours(sql)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.group_hours(sql)
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

  def self.ot_pay_hours(sql)
    otsetup = YAML.load_file(RAILS_ROOT + "/config/overtime_setup.yml")
    hours = 0
    items = self.group_hours(sql)
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
end
