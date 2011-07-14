require 'fastercsv' 
class ReportsController < ApplicationController
  layout "layouts/application" ,  :except => [:export, :time_report,:expense_export, :personalcharge_export, :billing_export]


  def index
    redirect_to :action => 'print'
  end


  def print
    init_set #people period project
    @periods2 = Period.find(:all, :order => 'number desc')
    @personalcharge = Personalcharge.new
    @now_user = session[:user_id]
    if @now_user == 0 
      @projects = Project.find( :all, 
        :order=>'job_code')
    end
    @ptrs =Project.find_by_sql("select distinct partner_id as id from projects;")
    @refs=Project.find_by_sql("select distinct referring_id as id from projects;")
    @mgrs=Project.find_by_sql("select distinct manager_id as id from projects;")
    @GMUs = Dict.find(:all, :conditions =>"category = 'GMU' ")
    @services = Dict.find(:all, :conditions =>"category = 'service_code' ")
    @clients = Client.find(:all, :order => "english_name")
    @statuses = Dict.find(:all, :conditions =>"category ='prj_status'")
    @contractNumbers = Project.find_by_sql("select distinct contract_number from projects order by contract_number;")
  end
  
  #################################3
  def time_report
    @info = Personalcharge.new(params[:personalcharge])
    @statuses   = Dict.find(:all,
      :conditions =>"category ='prj_status' and code = '1'")# 1 open, 0 close
                   
    #sql_p     = " starting_date => '2007-09-16' or status_id = #{@statuses.id}}"
    @project = Project.find(@info.project_id)
    @now_period = Period.find(@info.period_id)
    
    @report = TimeReport.new
    @report.for_report(@project, @now_period)
    #charges
    @personalcharges = @report.personalcharges
    @p_currents = @report.p_currents
    @p_cumulatives = @report.p_cumulatives
    @p_total  = @report.p_total
    @user_list = @report.user_list
    #expenses
    @e_current = @report.e_current
    @e_cumulative  = @report.e_cumulative
    sum_expenses = 0
    sum_e_total = 0
				
    sum_expenses 	+= @e_current.courrier
    sum_e_total 	+= @e_cumulative.courrier
    sum_expenses 	+= @e_current.postage
    sum_e_total 	+= @e_cumulative.postage
    sum_expenses 	+= @e_current.payment_on_be_half
	
    sum_expenses 	+= @e_current.report_binding
    sum_e_total 	+= @e_cumulative.report_binding
    sum_expenses 	+= @e_current.stationery
    sum_e_total 	+= @e_cumulative.stationery
    sum_expenses 	+= @e_current.tickets
    sum_e_total 	+= @e_cumulative.tickets
    #sum_expenses 	+= @e_current.commission
    #sum_e_total 	+= @e_cumulative.commission
    #sum_expenses 	+= @e_current.outsourcing
    #sum_e_total 	+= @e_cumulative.outsourcing
    sum_e_total 	+= @e_cumulative.payment_on_be_half
    #billings
    @billings  = @report.billings
    @billing_total   = @report.b_total
    @bt={}
    @bt        = @report.bt   
    sum_expenses 	+=@bt["current"]
    sum_e_total 	+=@bt["cumulative"]
    @sum_all_expenses = sum_expenses
    @sum_e_total    = sum_e_total  	
    
    #PFA and UFA
    @UFA_fees  = @report.UFA_fees
    @UFA_total   = @report.UFA_total
    
    @total_reimbs =  @p_total.travel_allowance  + @p_total.reimbursement + @p_total.meal_allowance
    #计算
     
    service_total_charges = @p_total.service_fee +  @e_cumulative.outsourcing + @e_cumulative.commission
    expense_total_charges = @sum_e_total  +@total_reimbs 
    
    service_PFA = (@p_total.service_fee )*@project.service_PFA/100 
    expense_PFA = (@total_reimbs+@sum_e_total-@e_cumulative.payment_on_be_half)*@project.expense_PFA/100 
    
    service_billing =@billing_total.service_billing 
    expense_billing = @billing_total.expense_billing 
    
    service_UFA = @UFA_total.service_UFA
    expense_UFA = @UFA_total.expense_UFA
    
    service_balance = service_total_charges - service_PFA - service_billing - service_UFA
    expense_balance = expense_total_charges - expense_PFA - expense_billing - expense_UFA
    
    if service_balance !=0 and  expense_balance != 0 #为0 允许close
      return false
    else
      true
    end
  end


  def export
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    headers['Cache-Control'] = ''
    @records = Personalcharge.find_by_sql(params[:sql])
    @total = Personalcharge.new(params[:total])
  end
 
  
  def personalcharges_export

    personalcharges = Person.find(current_user.person_id).my_personalcharges(session[:personalcharge_sql])

    csv_string = FasterCSV.generate do |csv|
      csv << ["NO","job_code","period","Date","employee","hours","Including OT hours","service_fee","description","state"]
      personalcharges.each do |e|
        csv << [
          e.id,
          e.project.job_code,
          e.period.number,
          e.charge_date,
          e.person.english_name,
          e.hours,
          e.ot_hours,
          e.desc,
          e.state] if  !e.person.nil? and !e.period.nil? and !e.project.nil?
      end
    end
    send_data csv_string, :type => "text/plain",
      :filename=>"personalcharges.csv",
      :disposition => 'attachment'
  end

  def expenses_export
    sum_expenses =Person.find(current_user.person_id).my_expenses(session[:expense_sql])

    csv_string = FasterCSV.generate do |csv|
      csv << ["NO","Date","Employee","Billable","Category","Client Name","Project Code","Amount","State"]
      sum_expenses.each do |e|
        csv << [
          e.id,
          e.charge_date,
          e.person.english_name,
          e.billable,
          e.expense_category,
          e.project.client.english_name,
          e.project.job_code,
          e.fee,
          e.state
        ] if  !e.person.nil? and !e.project.nil?
      end
    end
    send_data csv_string, :type => "text/plain",
      :filename=>"expenses.csv",
      :disposition => 'attachment'
  end

  def billing_export
    
    sql_str = params[:p_sql]
    sql_condition = params[:p_condition]
    sql_order = params[:p_order]
    
    @billings = Billing.find_by_sql(sql_str + sql_condition + sql_order )
    @sql=sql_str + sql_condition + sql_order

    
    join_sql =' inner join projects on projects.id = billings.project_id'
    @b_total = Billing.new
   
    @b_total.amount = Billing.sum("amount", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.outstanding = Billing.sum("outstanding", :joins=>join_sql, :conditions => sql_condition)||0
    @b_total.service_billing = Billing.sum("service_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.expense_billing = Billing.sum("expense_billing",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.business_tax = Billing.sum("business_tax",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.write_off = Billing.sum("write_off",:joins=>join_sql, :conditions => sql_condition)||0
    @b_total.provision = Billing.sum("provision",:joins=>join_sql, :conditions => sql_condition)||0
    @b_count = Billing.count(:joins=>join_sql,:conditions =>sql_condition)    ||0
   
  end
  
end
