class Period < ActiveRecord::Base
  validates :work_hours, numericality: true
  has_many :expenses
  has_many :personalcharges
  has_many :billings

  def name
    number
  end

  attr_accessible :id, :number, :work_hours, :starting_date, :ending_date, :created_on

  def self.today_period
    today = Time.now.to_date
    period_sql = " 1 and '#{today}' <= ending_date and '#{today}' >= starting_date"
    t_period = where(period_sql).first || order("number desc").first
  end
end
