class HomepageController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    if user_signed_in?
      @projects = current_user.projects
      check_period
    end
  end

  private
    def check_period(t = DateTime.now)
      this_period_number = t.beginning_of_month.to_date
      next_period_number = (t.beginning_of_month + 15.days).to_date     
      unless Period.find_by_number(this_period_number)
        Period.create(number:         this_period_number, 
                      starting_date:  t.beginning_of_month, 
                      ending_date:    (t.beginning_of_month + 14.days)) 
      end 
      

      unless Period.find_by_number(next_period_number)    
        Period.create(number:         next_period_number,
                      starting_date:  (t.beginning_of_month + 15.days),
                      ending_date:    t.end_of_month)
      end
    end
end