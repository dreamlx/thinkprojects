#coding: utf-8
class HomepageController < ApplicationController
  def index
    if logged_in?
      @projects = Project.my_projects(current_user)

      flash[:notice] = '请等待管理员分配用户，谢谢' if current_user.person_id.blank? or current_user.person_id.nil?

      check_period(DateTime.now)
      check_period("2012-01-01".to_date)
      check_period("2012-01-16".to_date)
      check_period("2012-02-01".to_date)
      check_period("2012-02-16".to_date)

    end
  end

  private
  def check_period(t = DateTime.now)
    this_period_number = t.beginning_of_month.strftime("%Y-%m-%d")
    next_period_number = (t.beginning_of_month + 15.days).strftime("%Y-%m-%d")
    if  (Period.find_by_number(this_period_number).nil?)      
      period = Period.new
      period.number = this_period_number
      period.starting_date = t.beginning_of_month
      period.ending_date = (t.beginning_of_month + 14.days) 
      period.save
    end

    if  (Period.find_by_number(next_period_number).nil?)      
      period = Period.new
      period.number = next_period_number
      period.starting_date = (t.beginning_of_month + 15.days) 
      period.ending_date = t.end_of_month
      period.save
    end
  end
end

      #%a - 星期几的英文简写 (``Sun'')
      #%A - 星期几的英文全称 (``Sunday'')
      #%b - 月份的英文简写 (``Jan'')
      #%B - 月份的英文全称 (``January'')
      #%c - 默认的首选本地时间输出格式
      #%d - 本月第几天 (01..31)
      #%H - 24小时制的小时 (00..23)
      #%I - 12小时制的小时 (01..12)
      #%j - 今年的第几天 (001..366)
      #%m - 月份 (01..12)
      #%M - 分钟 (00..59)
      #%p - 上午还是下午 (``AM''  or  ``PM'')
      #%S - 秒数 (00..60)
      #%U - 从星期天算一周开始的本年第几周 (00..53)
      #%W - 从星期一算一周开始的本年第几周 (00..53)
      #%w - 现在是星期几 (周日是0 , 0..6)
      #%x - 默认的日期输出格式 ("01/29/11")
      #%X - 默认的时间输出格式 ("21:47:07")
      #%y - 年份的后两位 (00..99)
      #%Y - 年份
      #%Z - 时区名
      #%% - 输出%字符
