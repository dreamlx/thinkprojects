class Period < ActiveRecord::Base
  validates :work_hours, numericality: true
  has_many :expenses
  has_many :personalcharges
  has_many :billings

  def name
    number
  end

  attr_accessible :number, :work_hours, :starting_date, :ending_date

  def self.search_by_sql(search,page)  
    paginate  :page => page, 
              :conditions => search,
              :order => "number"
  end
  
  def self.today_period
    today = Time.now.strftime("%Y-%m-%d")
    period_sql = " 1 and '#{today}' <= ending_date and '#{today}' >= starting_date"
    t_period = where(period_sql).first || order("number desc").first
  end

  def self.selected_numbers
    order("number").map {|p| [ p.number, p.id ] }
  end
end
