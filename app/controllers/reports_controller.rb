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

    sql = session[:personalcharge_sql]
    sql_ot =session[:personalcharge_ot] 

    personalcharges = Personalcharge.my_personalcharges(current_user,sql)
    approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
   
    @standard_hours = OverTime.standard_hours(approved_personalcharges)
    @ot_hours       = OverTime.ot_hours(approved_personalcharges)
    @ot_pay_hours   = OverTime.ot_pay_hours(approved_personalcharges)
    
    csv_string = FasterCSV.generate do |csv|
      csv << ["NO","Employee","Period","Charge Rate","Job Code","Hours","Including OT hours","Description","State"]
      personalcharges.each do |e|
        t_csv = [
          e.id,    
          e.person.english_name.humanize,
          e.period.number,
          e.charge_date,
           e.project.job_code,       
          e.hours,
          e.ot_hours,
          e.desc,
          e.state] if  !e.person.nil? and !e.period.nil? and !e.project.nil?

          csv << t_csv unless t_csv.nil?
        end
        csv << ["Standard hours","Including OT hours","OT pay hours"]
        csv << [@standard_hours, @ot_hours, @ot_pay_hours]
      end

      send_data csv_string, :type => "text/plain",
      :filename=>"personalcharges.csv",
      :disposition => 'attachment'
    end

    def expenses_export
      sum_expenses =Expense.my_expenses(current_user.person_id,session[:expense_sql])
      csv_string = FasterCSV.generate do |csv|
        csv << ["NO","Date","Employee","Billable","Category","Client Name","Project Code","Amount","State"]
        sum_expenses.each do |e|
          t_csv = [
            e.id,
            e.charge_date,
            e.person.english_name.humanize,
            e.billable,
            e.expense_category,
            e.project.client.english_name,
            e.project.job_code,
            e.fee,
            e.state
            ] if  !e.person.nil? and !e.project.nil? and !e.project.client.nil? and !e.project.nil?
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
