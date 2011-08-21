class Period < ActiveRecord::Base
  validates_numericality_of :work_hours

  has_many :expenses
  has_many :personalcharges

  has_many :billings

  def self.search_by_sql(search,page)
    
    paginate :per_page => 20, :page => page,
      :conditions=>search,:order=>"number"
  end
  
  def self.today_period
    today = Time.now.strftime("%Y-%m-%d")
    period_sql = " 1 and '#{today}' <= ending_date and '#{today}' >= starting_date"
    t_period = find(:first, :conditions => period_sql)||find(:first,:order=>"number desc")
    
    return t_period
  end
  # human names
  ModelName = "period"
  ColumnNames ={
    :number => "number",
    :starting_date => "starting_date",
    :ending_date => "ending_date"
  }
end
