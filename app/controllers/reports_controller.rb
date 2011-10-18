require 'fastercsv' 
class ReportsController < ApplicationController
  layout "layouts/application" ,  :except => [:export, :time_report,:expense_export, :personalcharges_export, :billing_export]


  def index
    
  end



  def export
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    headers['Cache-Control'] = ''
    @records = Personalcharge.find_by_sql(params[:sql])
    @total = Personalcharge.new(params[:total])
  end
 
  
  def personalcharges_export
    if request.post?
      sql = '1'
      sql += " and project_id = #{params[:project_id]}"           if params[:project_id].present?
      sql += " and projects.state = '#{params[:project_state]}' "  if params[:project_state].present?
      sql += " and manager_id = #{params[:manager_id]}"           if params[:manager_id].present?
      
      sql += " and periods.id = #{params[:period_id]}"            if params[:period_id].present?
    else
      sql = session[:personalcharge_sql]
    end

    if current_user.roles == "providence_breaker"
      personalcharges = Personalcharge.find(:all,:conditions=>sql,
        :order=>"personalcharges.state desc,projects.job_code", :include=>[:project,:period])
    else
      personalcharges = Personalcharge.my_personalcharges(current_user,sql)
    end


    csv_string = FasterCSV.generate do |csv|
      csv << ["NO","job_code","employee","period","Date","charge rate","hours","Including OT hours","service_fee","description","state"]
      personalcharges.each do |e|
        t_csv = [
          e.id,
          e.project.job_code,
          e.person.english_name,
          e.period.number,
          e.charge_date,
          e.person.charge_rate,
          e.hours,
          e.ot_hours,
          e.service_fee,
          e.desc,
          e.state] if  !e.person.nil? and !e.period.nil? and !e.project.nil?
          
          csv << t_csv.map {|e2| convert_gb(e2)} unless t_csv.nil?
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
        t_csv = [
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
        csv << t_csv.map {|e2| convert_gb(e2)} unless t_csv.nil?
        
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
