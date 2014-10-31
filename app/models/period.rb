class Period < ActiveRecord::Base
  validates :work_hours, numericality: true
  has_many :expenses
  has_many :personalcharges
  has_many :billings

  attr_accessible :number, :work_hours, :starting_date, :ending_date

  def self.search_by_sql(search,page)  
    paginate  :page => page, 
              :conditions => search,
              :order => "number"
  end
  
  def self.today_period
    today = Time.now.strftime("%Y-%m-%d")
    period_sql = " 1 and '#{today}' <= ending_date and '#{today}' >= starting_date"
    t_period = where(:conditions => period_sql).first || where(:order=>"number desc").first
    
    return t_period
  end
end
