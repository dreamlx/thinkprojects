class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  
  private
    def get_now_period
      cookie_period_id = cookies[:the_time]
      if cookie_period_id != ""
        sql_condition  = " id = '#{cookie_period_id}'"
      else
        sql_condition = "id = 0"
      end
      now_period = Period.where(sql_condition ).first || Period.today_period

    end

    def billing_number_set
      @billing_number = Dict.where(category: :billing_number).first
      @number = @billing_number.code.to_i + 1

      case @number
      when @number <10
        @str_number = "000" + @number.to_s
      when @number <100
        @str_number = "00" + @number.to_s
      when @number <1000
        @str_number = "0" + @number.to_s
      when
        @str_number = @number.to_s
      end
    end
end
