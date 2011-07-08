require 'fastercsv' 
class ReportsController < ApplicationController
  layout "layouts/application" ,  :except => [:export, :time_report,:expense_export, :personalcharge_export, :billing_export, :summary, :summary_by_user]


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
  
  def hours_export
    init_set
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = 'attachment; filename="hours-export.xls"'
    headers['Cache-Control'] = ''    
    sql_str ="select P.job_code, D.code as Service_line, E.english_name, sum(C.hours) as hours from personalcharges as C "
    + " inner join projects as P on C.project_id = P.id "
    + " inner join people as E on C.person_id = E.id "
    + " inner join dicts as D on P.service_id = D.id "
    + " group by english_name, job_code "
    + " order by english_name, job_code "
    @records = Personalcharge.sum_by_sql(sql_str)
  end
  
 
  
  def personalcharge_export
    personalcharge = Personalcharge.new(params[:personalcharge])
    sql = " 1 "
    sql += " and person_id =#{personalcharge.person_id} " if personalcharge.person_id.present?
    sql += " and project_id = #{personalcharge.project_id}" if personalcharge.project_id.present?
    sql += " and period_id =#{personalcharge.period_id}" if personalcharge.period_id.present?
    personalcharges = Personalcharge.find(:all,:conditions=>sql)
      csv_string = FasterCSV.generate do |csv|
            csv << ["job_code","period","employee","hours","service_fee","reimbursment","meal allowance","travel allowance","description","state"]
            personalcharges.each do |e|
              csv << [e.project.job_code,e.period.number,
                e.person.english_name,e.hours,e.service_fee,
                e.reimbursement,e.meal_allowance,e.travel_allowance,e.desc,e.state] if  !e.person.nil? and !e.period.nil? and !e.project.nil?
            end
          end
          send_data csv_string, :type => "text/plain",
           :filename=>"personalcharges.csv",
           :disposition => 'attachment'
  end

   def expenses_export
    sum_expenses =Expense.find(:all, :conditions=>session[:expense_sql],
      :joins=>" left join projects on project_id = projects.id
                left join clients on client_id = clients.id")

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
  
  def summary

    @people = Person.find(:all, :order => 'english_name')
     
    
    @info = Project.new(params[:project])
    @start_period = Period.find(params[:start_period_id])
    @end_period = Period.find(params[:end_period_id])
    

    @projects = Project.find( :all,
      :order=>'job_code',:joins=>"left join billings on billings.project_id = projects.id left join periods on periods.id = billings.period_id",
      :conditions=>    " periods.ending_date <='#{@end_period.ending_date}'  and periods.starting_date >='#{@start_period.starting_date}' ")



    project_sql = [" GMU_id =?", @info.GMU_id]
 
    reimb_sql = "select 	 PRJ.id as prj_id, PRJ.job_code as job_code,                          "+
      "          0 as Beg_travel,                 "+
      "	         0 as Beg_meal,                  "+
      "	         0 as Beg_per_dium,            "+
      "	sum(CHARGE.reimbursement) as cum_travel,                    "+
      "	sum(CHARGE.meal_allowance) as cum_meal,                     "+
      "	sum(CHARGE.travel_allowance) as cum_per_dium                "+
      " from projects 		as PRJ                                  "+
     
      " left join personalcharges as CHARGE on CHARGE.project_id = PRJ.id           "+
      " left join periods on periods.id = CHARGE.period_id                         "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id                                                       "+
      " order by job_code; "
    @reimbs = Expense.find_by_sql(reimb_sql)
  
    expense_sql = " select 	PRJ.id as prj_id, "+
      "           PRJ.job_code as job_code,                         "+
      "	( 	0 +      "+
      "		0 +             "+
      "		0 + 0         "+
      "	) as Beg_expense,                                         "+
      "	sum(E.tickets) as Ticket,                                 "+
      "	sum(E.courrier) as Courrier,                              "+
      "	sum(E.postage) as Postage,                                "+
      "	sum(E.stationery) as Stationery,                          "+
      "	sum(E.report_binding) as Report_binding,                  "+
      "	sum(E.payment_on_be_half) as Payment_on_be_half,          "+
      "	(	sum(E.tickets) + sum(E.courrier) +                    "+
      "		sum(E.postage) + sum(E.stationery) +                  "+
      "		sum(E.report_binding) + sum(E.payment_on_be_half)     "+
      "	) as Sub_expense                                          "+
      " from projects 		as PRJ                                "+
     
      " left join expenses 	  as E      on E.project_id = PRJ.id           "+
      " left join periods on periods.id = E.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id                                                       "+
      " order by job_code;                                                          "
    @expenses = Expense.find_by_sql(expense_sql)            

    billing_sql =   " select	PRJ.id as prj_id, PRJ.job_code            as job_code, "+
      "	        0     as Beg_service, "+
      "	        sum(B.service_billing)  as Service_billing,	"+  
      "	        0    as Beg_expense, "+
      "	        sum(B.expense_billing)  as Expense_billing,	"+
      "	        sum(B.business_tax)     as BT "+
      " from projects 		            as PRJ "+
      #" left join deductions 	        as I_D    on I_D.project_id = PRJ.id "+
      " left join billings 	            as B      on B.project_id = PRJ.id "+
      " left join periods on periods.id = B.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id "+
      " order by PRJ.job_code; "
    @billings = Billing.find_by_sql(billing_sql)

    ufa_sql = "select 	PRJ.id as prj_id, PRJ.job_code as job_code,     "+
      "	0 as Beg_service,           "+
      "	sum(U.service_UFA) as Service_UFA,     "+
      "	0 as Beg_expense,           "+
      "	sum(U.expense_UFA) as Expense_UFA     "+
      " from projects 		as PRJ            "+
      #" left join deductions 	  as I_D    on I_D.project_id = PRJ.id  "+
      " left join ufafees 	as U	on U.project_id = PRJ.id            "+
      " group by PRJ.id "+
      " order by job_code; "
    @ufas = Ufafee.find_by_sql(ufa_sql)
  
    fee_PFA_sql =
      " select 	PRJ.id as prj_id, PRJ.job_code as job_code, "+
      "	PRJ.service_PFA,"+
      "	0 as Beg_service_fee,"+
      "	sum(CHARGE.service_fee) as Service_fee,"+
      "	0 as Beg_PFA,"+
      "	sum(CHARGE.service_fee)/100*PRJ.service_PFA as PFA"+
      " from projects 		           as PRJ"+
     
      " left join personalcharges    as CHARGE on CHARGE.project_id = PRJ.id"+
      " left join periods on periods.id = CHARGE.period_id"+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+

      " group by PRJ.id"+
      " order by job_code;"
    @service_pfa = Project.find_by_sql(fee_PFA_sql)
  
    co_sql = 
      " select PRJ.id as prj_id, PRJ.job_code, "+
      " 0 as CO_Beg, "+
      " sum(E.commission)       as commission, sum(E.outsourcing) as outsourcing"+
      " from projects as PRJ"+
    
      " left join expenses        as E on E.project_id = PRJ.id "+
      " left join periods on periods.id = E.period_id                       "+
      " where periods.ending_date <='#{@end_period.ending_date}'                       "+
      " and periods.starting_date >='#{@start_period.starting_date}' "+
      " group by PRJ.id"+
      " order by job_code;"
    @co_fees = Commission.find_by_sql(co_sql)
  
    @srecords ={}
    @i=0
    for record in @projects
    
      summaryRecord = Summary.new
      summaryRecord.id = record.id.to_s
      summaryRecord.GMU = record.GMU.title
      summaryRecord.job_code = record.job_code
      summaryRecord.clien_name = record.client.english_name
      summaryRecord.job_Ref = record.referring.english_name
      summaryRecord.job_Ptr = record.partner.english_name
      summaryRecord.job_Mgr = record.manager.english_name
      summaryRecord.service_line = record.service_code.code
      summaryRecord.service_PFA = record.service_PFA
      summaryRecord.expense_PFA = record.expense_PFA
      summaryRecord.contract_number = record.contract_number
      summaryRecord.contracted_fee = record.contracted_service_fee
      summaryRecord.contracted_expense = record.contracted_expense
      summaryRecord.project_status = record.status.title
    
      for fee in @service_pfa
        if record.id.to_s == fee.prj_id.to_s
          summaryRecord.fees_Beg = fee.Beg_service_fee||0
          summaryRecord.fees_Cum = fee.Service_fee||0
          summaryRecord.fees_Sub = fee.Beg_service_fee.to_i + fee.Service_fee.to_i||0
   
          summaryRecord.PFA_Beg = fee.Beg_PFA||0
          summaryRecord.PFA_Cum = fee.PFA||0
          summaryRecord.PFA_Sub = fee.Beg_PFA.to_i + fee.PFA.to_i||0
        end
      end
    


      for billing in @billings
        if record.id.to_s == billing.prj_id.to_s
          summaryRecord.Billing_Beg = billing.Beg_service||0
          summaryRecord.Billing_Cum = billing.Service_billing||0
          summaryRecord.Billing_Sub = billing.Beg_service.to_i + billing.Service_billing.to_i||0
          summaryRecord.BT = billing.BT||0
        end
      end
      #summaryRecord.INVENTORY_BALANCE = 0
      #summaryRecord.INVPER = 0
      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i
    
      if summaryRecord.contracted_fee == 0
        summaryRecord.INVPER = 0
      else  
        summaryRecord.INVPER = (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 
      end
      @srecords["#{@i}"] = summaryRecord
      @i = @i +1
    end
 
  end
  
  def summary_by_user
    #headers['Content-Type'] = "application/vnd.ms-excel" 
    #headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    #headers['Cache-Control'] = ''  
    prj_status = Dict.find_by_title_and_category("Active","prj_status")
    
    @people = Person.find(:all, :order => 'english_name')  
    @info = Project.new(params[:project])
    @pm =params[:pm_select]
    @now_user = session[:user_id]
    @period = Period.find(params[:period_id]) 
    @period2 = Period.find(params[:period_id2]) 
    sql_condition = " 1 "
    
    sql_condition += " AND GMU_id = #{@info.GMU_id} " if @info.GMU_id != -1
    sql_condition += " AND service_id = #{@info.service_id} " if @info.service_id != -1

    if @pm == 'p'
      sql_condition += " AND partner_id = #{@info.partner_id} "
    elsif @pm =='m'
      sql_condition += " AND manager_id = #{@info.manager_id} "
    else
      sql_condition += " AND partner_id = #{@info.partner_id} " if @info.partner_id != -1 and not @info.partner_id.blank?
      sql_condition += " AND manager_id = #{@info.manager_id} " if @info.manager_id != -1 and not @info.manager_id.blank?
    end

    sql_condition += " AND referring_id = #{@info.referring_id} " if @info.referring_id != -1
    sql_condition += " AND job_code like '#{@info.job_code}%' " if @info.job_code != ""
    sql_condition += " AND contract_number = '#{@info.contract_number}' " if @info.contract_number != '-1'
    sql_condition += " AND status_id = #{@info.status_id} " if @info.status_id != -1
    sql_condition += " and starting_date >='#{@period2.starting_date}'" 
    @tmp_sql = sql_condition 
    @projects = Project.find( :all,             
      :conditions => sql_condition,               
      :order=>'job_code')


    #period_sql  = [" periods.ending_date <= ?", @period.ending_date]
    project_sql = [" GMU_id =?", @info.GMU_id]
 
    reimb_sql = "select 	 PRJ.id as prj_id, PRJ.job_code as job_code,                          "+
      "          I_FEE.reimbursement as Beg_travel,                 "+
      "	         I_FEE.meal_allowance as Beg_meal,                  "+
      "	         I_FEE.travel_allowance as Beg_per_dium,            "+
      "	sum(CHARGE.reimbursement) as cum_travel,                    "+
      "	sum(CHARGE.meal_allowance) as cum_meal,                     "+
      "	sum(CHARGE.travel_allowance) as cum_per_dium                "+

      " from projects 		as PRJ                                  "+
      
      " left join personalcharges as CHARGE on CHARGE.project_id = PRJ.id           "+
      " right join periods on periods.id = CHARGE.period_id                         "+
      " where periods.ending_date <='#{@period.ending_date}'                        "+
      " group by PRJ.id                                                       "+
      " order by job_code; "
    @reimbs = Expense.find_by_sql(reimb_sql)
  
    expense_sql = " select 	PRJ.id as prj_id, "+
      "           PRJ.job_code as job_code,                         "+
      "	( 	I_FEE.tickets + I_FEE.courrier + I_FEE.postage +      "+
      "		I_FEE.stationery + I_FEE.report_binding +             "+
      "		I_FEE.payment_on_be_half + I_FEE.business_tax         "+
      "	) as Beg_expense,                                         "+
      "	sum(E.tickets) as Ticket,                                 "+
      "	sum(E.courrier) as Courrier,                              "+
      "	sum(E.postage) as Postage,                                "+
      "	sum(E.stationery) as Stationery,                          "+
      "	sum(E.report_binding) as Report_binding,                  "+
      "	sum(E.payment_on_be_half) as Payment_on_be_half,          "+
      "	(	sum(E.tickets) + sum(E.courrier) +                    "+
      "		sum(E.postage) + sum(E.stationery) +                  "+
      "		sum(E.report_binding) + sum(E.payment_on_be_half)     "+
      "	) as Sub_expense                                          "+
      " from projects 		as PRJ                                "+
     
      " left join expenses 	  as E      on E.project_id = PRJ.id           "+
      " right join periods on periods.id = E.period_id                       "+
      " where periods.ending_date <='#{@period.ending_date}'                                      "+

      " group by PRJ.id                                                       "+
      " order by job_code;                                                          "
    @expenses = Expense.find_by_sql(expense_sql)            

    billing_sql =   " select	PRJ.id as prj_id, PRJ.job_code            as job_code, "+
      "	        I_D.service_billing     as Beg_service, "+
      "	        sum(B.service_billing)  as Service_billing,	"+  
      "	        I_D.expense_billing     as Beg_expense, "+
      "	        sum(B.expense_billing)  as Expense_billing,	"+
      "	        sum(B.business_tax)     as BT "+
      " from projects 		            as PRJ "+
      " left join deductions 	        as I_D    on I_D.project_id = PRJ.id "+
      " left join billings 	            as B      on B.project_id = PRJ.id "+
      " right join periods on periods.id = B.period_id                       "+
      " where periods.ending_date <='#{@period.ending_date}'                                      "+
      " group by PRJ.id "+
      " order by PRJ.job_code; "
    @billings = Billing.find_by_sql(billing_sql)

    ufa_sql = "select 	PRJ.id as prj_id, PRJ.job_code as job_code,     "+
      "	I_D.service_UFA as Beg_service,           "+
      "	sum(U.service_UFA) as Service_UFA,     "+
      "	I_D.expense_UFA as Beg_expense,           "+
      "	sum(U.expense_UFA) as Expense_UFA     "+
      " from projects 		as PRJ            "+
      " left join deductions 	  as I_D    on I_D.project_id = PRJ.id  "+
      " left join ufafees 	as U	on U.project_id = PRJ.id            "+

      " group by PRJ.id "+
      " order by job_code; "
    @ufas = Ufafee.find_by_sql(ufa_sql)
  
    fee_PFA_sql =
      " select 	PRJ.id as prj_id, PRJ.job_code as job_code, "+
      "	PRJ.service_PFA,"+
      "	I_FEE.service_fee as Beg_service_fee,"+
      "	sum(CHARGE.service_fee) as Service_fee,"+
      "	I_D.service_PFA as Beg_PFA,"+
      "	sum(CHARGE.service_fee)/100*PRJ.service_PFA as PFA"+
      " from projects 		           as PRJ"+
     
      " left join deductions 	       as I_D    on I_D.project_id = PRJ.id"+
      " left join personalcharges    as CHARGE on CHARGE.project_id = PRJ.id"+
      " right join periods on periods.id = CHARGE.period_id"+
      " where periods.ending_date <='#{@period.ending_date}'"+

      " group by PRJ.id"+
      " order by job_code;"
    @service_pfa = Project.find_by_sql(fee_PFA_sql)
  
    co_sql = 
      " select PRJ.id as prj_id, PRJ.job_code, "+
      " I_FEE.commission + I_FEE.outsourcing as CO_Beg, "+
      " sum(E.commission)       as commission, sum(E.outsourcing) as outsourcing"+
      " from projects as PRJ"+
     
      " left join expenses        as E on E.project_id = PRJ.id "+
      " where  1 "+    
      " group by PRJ.id"+
      " order by job_code;"
    @co_fees = Commission.find_by_sql(co_sql)
  
    @srecords ={}
    @i=0
    for record in @projects
    
      summaryRecord = Summary.new
      summaryRecord.id = record.id.to_s
      summaryRecord.GMU = record.GMU.title||""
      summaryRecord.job_code = record.job_code||""
      summaryRecord.clien_name = record.client.english_name||""
      summaryRecord.job_Ref = record.referring.english_name||""
      summaryRecord.job_Ptr = record.partner.english_name||""
      summaryRecord.job_Mgr = record.manager.english_name||""
      summaryRecord.service_line = record.service_code.code||""
      summaryRecord.service_PFA = record.service_PFA||0
      summaryRecord.expense_PFA = record.expense_PFA||0
      summaryRecord.contract_number = record.contract_number||"--"
      summaryRecord.contracted_fee = record.contracted_service_fee||0
      summaryRecord.contracted_expense = record.contracted_expense||0
      summaryRecord.project_status = record.status.title||""
    
      for fee in @service_pfa
        if record.id.to_s == fee.prj_id.to_s
          summaryRecord.fees_Beg = fee.Beg_service_fee||0
          summaryRecord.fees_Cum = fee.Service_fee||0
          summaryRecord.fees_Sub = fee.Beg_service_fee.to_i + fee.Service_fee.to_i||0
   
          summaryRecord.PFA_Beg = fee.Beg_PFA||0
          summaryRecord.PFA_Cum = fee.PFA||0
          summaryRecord.PFA_Sub = fee.Beg_PFA.to_i + fee.PFA.to_i||0
        end
      end
    

    
      for billing in @billings
        if record.id.to_s == billing.prj_id.to_s
          summaryRecord.Billing_Beg = billing.Beg_service||0
          summaryRecord.Billing_Cum = billing.Service_billing||0
          summaryRecord.Billing_Sub = billing.Beg_service.to_i + billing.Service_billing.to_i||0
          summaryRecord.BT = billing.BT||0
        end
      end
      #summaryRecord.INVENTORY_BALANCE = 0
      #summaryRecord.INVPER = 0
      summaryRecord.INVENTORY_BALANCE = summaryRecord.fees_Cum.to_i - summaryRecord.PFA_Cum.to_i - summaryRecord.Billing_Cum.to_i
    
      if summaryRecord.contracted_fee == 0
        summaryRecord.INVPER = 0
      else  
        summaryRecord.INVPER = (summaryRecord.Billing_Cum.to_i / summaryRecord.contracted_fee )* 100 
      end
      @srecords["#{@i}"] = summaryRecord
      @i = @i +1
    end
 
  end
  
  private
  def get_summary_record(params_info,period)
    summary_record = {
      'id'  => "",
      'GMU' => "",
      'job_code' => "",
      'clien_name' => "",
      'job_Ref' => "",
      'job_Ptr' => "",
      'job_Mgr' => "",
      'service_line' => "",
      'service_PFA' => "",
      'contracted_fee' => "",
      'contracted_expense' => "",
      'project_status' => "",
      'fees_Beg' => 0,
      'fees_Cum' => 0,
      'fees_Sub' => 0,
      'PFA_Beg' => 0,
      'PFA_Cum' => 0,
      'PFA_Sub' => 0,        
      'Billing_Beg' => 0,	
      'Billing_Cum' => 0,	
      'Billing_Sub' => 0,	        	
      'BT' => 0,    
    		
      'INVENTORY_BALANCE' =>""    
    }
    
      
    @info = params_info
    @projects = Project.find(:all)
    @now_period = Period.find(period)
    
    

  end
end
