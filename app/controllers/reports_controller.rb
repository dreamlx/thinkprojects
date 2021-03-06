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

    def clients_export
      @clients = Client.find(:all)
      respond_to do |format|
        format.xls { send_data @clients.to_xls,:filename=>"clients.xls",
        :disposition => 'attachment' }
      end
    end

  def personalcharges_export

    sql = session[:personalcharge_sql]
    sql_ot =session[:personalcharge_ot] 

    personalcharges = Personalcharge.my_personalcharges(current_user,sql)
    if current_user.roles == 'staff'  or current_user.roles == 'senior'
      temp =personalcharges.map{|e| e.person_id == current_user.person_id ? e : nil}.compact
      personalcharges = temp
    end
    approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
   
    @standard_hours = OverTime.standard_hours(approved_personalcharges)
    @ot_hours       = OverTime.ot_hours(approved_personalcharges)
    @ot_pay_hours   = OverTime.ot_pay_hours(approved_personalcharges)

      respond_to do |format|
        original_xls_str = personalcharges.to_xls(:except => [:person_id, :period_id, :project_id], :methods => [:employee, :period_number, :job_code]).gsub("</Table></Worksheet></Workbook>","")
        overtime_title_str = original_xls_str +"<Row><Cell><Data ss:Type=\"String\">Standard hours</Data></Cell><Cell><Data ss:Type=\"String\">Including OT hours</Data></Cell><Cell><Data ss:Type=\"String\">OT pay hours</Data></Cell></Row>"
        overtime_val_str = overtime_title_str + "<Row><Cell><Data ss:Type=\"String\">#{@standard_hours}</Data></Cell><Cell><Data ss:Type=\"String\">#{@ot_hours}</Data></Cell><Cell><Data ss:Type=\"String\">#{@ot_pay_hours} </Data></Cell></Row>"
        final_xls_str = overtime_val_str + "</Table></Worksheet></Workbook>"

        format.xls { send_data final_xls_str,:filename=>"personalcharges.xls",
        :disposition => 'attachment' }
      end      
    # csv_string = FasterCSV.generate do |csv|
    #   csv << ["NO","Employee","Period","Charge Rate","Job Code","Hours","Including OT hours","Description","State"]
    #   personalcharges.each do |e|
    #     t_csv = [
    #       e.id,    
    #       e.person.nil? ? "" : e.person.english_name.humanize,
    #       e.period.nil? ? "" : e.period.number,
    #       e.charge_date,
    #       e.project.nil? ? "" : e.project.job_code,       
    #       e.hours,
    #       e.ot_hours,
    #       e.desc,
    #       e.state] #if  !e.person.nil? and !e.period.nil? and !e.project.nil?

    #       csv << t_csv unless t_csv.nil?
    #     end
    #     csv << ["Standard hours","Including OT hours","OT pay hours"]
    #     csv << [@standard_hours, @ot_hours, @ot_pay_hours]
    #   end

    #   send_data csv_string, :type => "text/csv",
    #   :filename=>"personalcharges.csv",
    #   :disposition => 'attachment'
    end

    def expenses_export
      expenses =Expense.my_expenses(current_user,session[:expense_sql])
      respond_to do |format|
        format.xls { send_data expenses.to_xls(:except => [:person_id, :project_id, :approved_by], :methods => [:employee, :client_name, :project_code, :approved_name]),:filename=>"expenses.xls",
        :disposition => 'attachment' }
      end      
      # csv_string = FasterCSV.generate do |csv|
      #   csv << ["NO","Date","Employee","Billable","Category","Client Name","Project Code","Amount","State"]
      #   expenses.each do |e|
      #     t_csv = [
      #       e.id,
      #       e.charge_date,
      #       e.person.nil? ? "" : e.person.english_name.humanize,
      #       e.billable,
      #       e.expense_category,
      #       (!e.project.nil? and !e.project.client.nil?) ? e.project.client.english_name : "",
      #       e.project.nil? ? "" : e.project.job_code,
      #       e.fee,
      #       e.state
      #       ] #if  !e.person.nil? and !e.project.nil? and !e.project.client.nil? and !e.project.nil?
          
      #       csv << t_csv
      #       #.map {|e2| convert_gb(e2)} unless t_csv.nil?

      #     end
      #   end
      #   send_data csv_string, :type => "text/csv",
      #   :filename=>"expenses.csv",
      #   :disposition => 'attachment'
      end    

    # def expenses_export
    #   expenses =Expense.my_expenses(current_user,session[:expense_sql])
      
    #   csv_string = FasterCSV.generate do |csv|
    #     csv << ["NO","Date","Employee","Billable","Category","Client Name","Project Code","Amount","State"]
    #     expenses.each do |e|
    #       t_csv = [
    #         e.id,
    #         e.charge_date,
    #         e.person.english_name.humanize,
    #         e.billable,
    #         e.expense_category,
    #         e.project.client.english_name,
    #         e.project.job_code,
    #         e.fee,
    #         e.state
    #         ] if  !e.person.nil? and !e.project.nil? and !e.project.client.nil? and !e.project.nil?
    #         csv << t_csv.map {|e2| convert_gb(e2)} unless t_csv.nil?

    #       end
    #     end
    #     send_data csv_string, :type => "text/plain",
    #     :filename=>"expenses.csv",
    #     :disposition => 'attachment'
    #   end

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
