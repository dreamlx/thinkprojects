#coding: utf-8
class HomepageController < ApplicationController
  def index
    if user_signed_in?
      @projects = Project.my_projects(current_user)
      check_period(DateTime.now)
    end
  end

  private
    def check_period(t = DateTime.now)
      this_period_number = t.beginning_of_month.strftime("%Y-%m-%d")
      next_period_number = (t.beginning_of_month + 15.days).strftime("%Y-%m-%d")
      unless Period.find_by_number(this_period_number)      
        period = Period.new
        period.number = this_period_number
        period.starting_date = t.beginning_of_month
        period.ending_date = (t.beginning_of_month + 14.days) 
        period.save
      end

      unless Period.find_by_number(next_period_number)    
        period = Period.new
        period.number = next_period_number
        period.starting_date = (t.beginning_of_month + 15.days) 
        period.ending_date = t.end_of_month
        period.save
      end
    end
end