class OverTime
  attr_accessor :working_days, :daily_working_hours, :holidays, :ineffective_code
  @@otsetup = YAML.load_file(Rails.root + "config/overtime_setup.yml")
  def initialize

    @working_days = @@otsetup["working_days"]
    @daily_working_hours = @@otsetup["daily_working_hours"]
    @holidays = @@otsetup["holidays"]
    @ineffective_code = @@otsetup["ineffective_code"]
  end
  
  def self.remove_ineffective_hours(items)
    removed = items.each{|item| @@otsetup["ineffective_code"].include?(Project.find(item.project_id).job_code) ? item : nil }
    removed.compact
  end
  
  def self.standard_hours(items)
    hours = 0

    items.each{|i|
      if i.charge_date
      if @@otsetup["working_days"].include?(i.charge_date.to_date.wday) #current day is work day?
        unless self.is_holiday?(i.charge_date)
          hours += @@otsetup["daily_working_hours"]
        end
      end
    end
    }
    return hours
  end

  def self.ot_hours(items)

    hours = 0

    standard_hours = self.standard_hours(items)

    items.each{|i|
      hours += i.hours
    }
    
    hours = hours - standard_hours
    return hours
  end

  def self.ot_pay_hours(items)
    #标准，1.5， 周末2，假日3. 计算方式，全部-1. ot pay，1.5-1，2-1，3-1= 0.5，1，2；
    #计算ＯＴ,全部； 计算ＯＴ pay 需要判断 approve状态。
    
    #holiday
    #weekend without holiday
    # standard without holiday
    hours = 0
    items.each{|i|
      if i.charge_date
      if self.is_holiday?(i.charge_date)
        hours += (i.hours * 2)
      elsif !self.is_standard_day?(i.charge_date) #weekend
        hours += (i.hours * 1) 
      elsif i.hours - @@otsetup["daily_working_hours"] >0
        hours += ((i.hours - @@otsetup["daily_working_hours"])* 0.5)
      else 
        hours += 0
      end
    end
    }
    return hours
  end
  
  def self.allow_ot?(current_item,items)
    flag = true 
    if current_item.ot_hours != 0
      
      sum_hours = 0
    items.each{|item|
      sum_hours += item.hours if (item.charge_date == current_item.charge_date and item.person_id == current_item.person_id)
      }
      if sum_hours - @@otsetup["allow_charge_hours"] >0
        flag = true
      else
        flag = false
      end
    end
    return flag
  end
  #####################################
  private

  def self.is_holiday?(current_date)
    
    if current_date
    @@otsetup["holidays"].each{|holiday| 
      flag = true if Date.parse(holiday).to_s == current_date.to_s 
    }
  else
  flag = false
  end
    return flag
  end

  def self.is_standard_day?(current_date)
    
    if current_date  
    flag = true if @@otsetup["working_days"].include?(current_date.to_date.wday)
  else
  flag = false  
  end
  
    return flag
  end
end