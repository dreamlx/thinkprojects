# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include AuthenticatedSystem

  helper_method :current_user, :logged_in?
  filter_parameter_logging :password,:password_confirmation
  before_filter :set_current_user

  #before_filter :configure_charsets
  def configure_charsets
    # Set connection charset. MySQL 4.0 doesn��t support this so it
    #will throw an error, MySQL 4.1 needs this
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end


  protected
  def permission_denied
    respond_to do |format|
      flash[:error] = '对不起，您没有足够的权限访问此页！'
      format.html { redirect_to :controller=>'homepage' }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end



  private

  def add_expense_observer(job_code,price=100,msg="")
    now_period = Period.today_period
    prj_status = Dict.find_by_title_and_category("Active","prj_status")
    prj = Project.find(:first,
      :conditions=>" 1 and (job_code like '%"+job_code+"%') and status_id =#{prj_status.id}")
    #需要判断项目是否已经关闭
    unless prj.nil?
      @expense = Expense.new
      @expense.project_id = prj.id
      @expense.period_id = now_period.id
      @expense.report_binding = price
      @expense.memo = msg
      @expense.save
      log = PrjExpenseLog.new
      log.period_id = now_period.id
      log.prj_id = prj.id
      log.expense_id = @expense.id
      log.other =( prj.job_code + "|" + msg)
      log.save
    end
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to(:action => 'index')
  end

  def get_cookie
    cookie_value = cookies[:the_time]
    #cookie_value ||= 0
    return cookie_value
    #render(:action=>index,:text =>" #{cookie_value}")
  end

  def get_now_period
    cookie_period_id = cookies[:the_time]
    if cookie_period_id != ""
      sql_condition  = " id = '#{cookie_period_id}'"
    else
      sql_condition = "id = 0"
    end
    now_period = Period.find(:first, :conditions => sql_condition )|| Period.today_period

    return now_period
  end

  def init_set
    prj_status = Dict.find_by_title_and_category("Active","prj_status")
    person_status = Dict.find_by_title_and_category("Resigned","person_status")
    @people = Person.find(:all,
      :conditions => "status_id != '#{person_status.id}' ",
      :order => 'english_name')

    @projects = Project.find( :all, :conditions=>" status_id =#{prj_status.id}",

      :order=>'job_code')
    @periods = Period.find(:all, :order => 'number DESC')

  end

  def billing_number_set
    @billing_number = Dict.find(:first, :conditions =>" category ='billing_number' ")
    @number = @billing_number.code.to_i + 1

    if @number <10
      @str_number = "000" + @number.to_s
    elsif @number <100
      @str_number = "00" + @number.to_s
    elsif @number <1000
      @str_number = "0" + @number.to_s
    else
      @str_number = @number.to_s
    end
  end

  def get_level
    #guest,employee,manager,director,providence_breaker
    level = Authorization.current_user.role_symbols.to_s
    return level

  end
  
  protected
  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound
      render_404
    else
      render_500
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_current_user
    Authorization.current_user = current_user
  end

end
