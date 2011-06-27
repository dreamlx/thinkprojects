# To change this template, choose Tools | Templates
# and open the template in the editor.

class TimeReport

  attr_reader :personalcharges
  attr_reader :p_total
  attr_reader :p_currents
  attr_reader :p_cumulatives
  attr_reader :user_list
  attr_reader :e_current
  attr_reader :e_cumulative
  attr_reader :billings
  attr_reader :b_total

  attr_reader :deduction
  attr_reader :bt
  attr_reader :UFA_fees
  attr_reader :UFA_total
  def initialize
    @personalcharges = Personalcharge.new
    @p_total = Personalcharge.new
    @p_currents = []
    @p_cumulatives = []
    @user_list = []

    @e_current = []
    @e_cumulative = []
    @billings = Billing.new
    @b_total = Billing.new

   
    @deduction  = Deduction.new
    @bt         = {}

    @UFA_fees ={}
    @UFA_total = Ufafee.new
  end

  def for_report(project, period)
    sql_condition     = " project_id = #{project.id} and period_id ='#{period.id}' "
    sql_condition2     = " project_id = #{project.id} and periods.ending_date <= '#{period.ending_date}' "
    sql_all_by_project    = " project_id = #{project.id} "
    sql_join          = " inner join people on personalcharges.person_id = people.id inner join periods on periods.id = period_id "
    sql_order         = " english_name "
    #" and billing_date <= '#{@period.ending_date}' and billing_date >= '#{@period.starting_date}' "
    #person charges
    @personalcharges  = Personalcharge.find(:all, :conditions => sql_condition2, :joins => sql_join, :order => sql_order)
    @user_list = Personalcharge.find_by_sql("select distinct person_id, english_name, charge_rate, employee_number from personalcharges " + sql_join +
        " where " + sql_all_by_project + " order by english_name" )
    for user in @user_list
      #flag = 1 is current, flag = 0 is cumulatives
      @p_currents     << sum_personalcharge(project.id, user.person_id, period, 1)
      @p_cumulatives  << sum_personalcharge(project.id, user.person_id, period, 0)
    end
    @p_total = sum_personalcharge(project.id, nil, period, 0)

    #expenses
    @e_current     = sum_expense(project.id, period, 1)
    @e_cumulative  = sum_expense(project.id, period, 0)


    #billings
    #@billings =Billing.find_by_sql("select billings.* from billings " + "inner join periods on periods.id = period_id " + " where 1 and " + sql_condition2 +" order by billings.number" )
    @billings = Billing.find( :all,
      :include =>:period,
      :order => 'billings.number',
      :conditions => sql_condition2)
    @b_total.service_billing  = Billing.sum("service_billing",
      :include =>:period,
      :conditions => sql_condition2)||0
    @b_total.expense_billing  = Billing.sum("expense_billing",
      :include =>:period,
      :conditions => sql_condition2)||0

    @bt["current"]     = Billing.sum( "business_tax",
      :conditions => sql_condition)||0
    @bt["cumulative"]  = Billing.sum(         "business_tax",
      :include =>:period,
      :conditions => sql_condition2)||0
   
    @deduction  = Deduction.find(:first,        :conditions => sql_all_by_project) || Deduction.new

    #PFA and UFA
    @UFA_fees   = Ufafee.find(:all, :include =>:period,:conditions => sql_condition2, :order => ' ufafees.number ')
    @UFA_total.service_UFA  = Ufafee.sum("service_UFA", :include =>:period, :conditions => sql_condition2)||0
    @UFA_total.expense_UFA  = Ufafee.sum("expense_UFA", :include =>:period, :conditions => sql_condition2)||0
  end
  private
  def sum_personalcharge(project_id = nil, person_id=nil, period=nil, flag = nil )
    #flag = 1 is current, flag = 0 is cumulatives
    sql_join          = " inner join periods on periods.id = period_id "
    sql_condition = " 1 "
    sql_condition += " and project_id = #{project_id}" unless project_id.nil?
    sql_condition += " and person_id = #{person_id} " unless person_id.nil?
    if flag == 1
      sql_condition += " and period_id = #{period.id} " unless period.nil?
    end

    if flag == 0
      sql_condition += " and periods.ending_date <= '#{period.ending_date}' " unless period.nil?
    end

    @p = Personalcharge.new
    @p.person_id = person_id

    @p.project_id = project_id
    @p.service_fee      = Personalcharge.sum("service_fee",         :joins => sql_join,:conditions => sql_condition) ||0
    @p.hours            = Personalcharge.sum("hours",               :joins => sql_join,:conditions => sql_condition) ||0
    @p.reimbursement    = Personalcharge.sum("reimbursement",       :joins => sql_join,:conditions => sql_condition) ||0
    @p.meal_allowance   = Personalcharge.sum("meal_allowance",      :joins => sql_join,:conditions => sql_condition) ||0
    @p.travel_allowance = Personalcharge.sum("travel_allowance",    :joins => sql_join,:conditions => sql_condition) ||0
    @p.updated_on       = Personalcharge.maximum("updated_on",      :joins => sql_join,:conditions => sql_condition)|| nil
    #@p.period_id = period.id||nil
    return @p
  end

  def sum_expense(project_id = nil, period=nil, flag = nil)
    sql_join          = " inner join periods on periods.id = period_id "
    sql_condition = " 1 "
    sql_condition += " and project_id = #{project_id}" unless project_id.nil?

    if flag == 1
      sql_condition += " and period_id = #{period.id} " unless period.nil?
    end

    if flag == 0
      sql_condition += " and periods.ending_date <= '#{period.ending_date}' " unless period.nil?
    end
    @e            = Expense.new
    #@e.period_id  = period_id
    @e.project_id = project_id
    @e.tickets            = Expense.sum("tickets",      :joins => sql_join,:conditions => sql_condition )||0
    @e.courrier           = Expense.sum("courrier",     :joins => sql_join,:conditions => sql_condition )||0
    @e.postage            = Expense.sum("postage",      :joins => sql_join,:conditions => sql_condition )||0
    @e.stationery         = Expense.sum("stationery",         :joins => sql_join, :conditions => sql_condition )||0
    @e.report_binding     = Expense.sum("report_binding",     :joins => sql_join, :conditions => sql_condition )||0
    @e.payment_on_be_half = Expense.sum("payment_on_be_half", :joins => sql_join, :conditions => sql_condition )||0
    @e.commission         = Expense.sum("commission",         :joins => sql_join, :conditions => sql_condition )||0
    @e.outsourcing        = Expense.sum("outsourcing",        :joins => sql_join, :conditions => sql_condition )||0
    @e.updated_on         = Expense.maximum("updated_on",     :joins => sql_join, :conditions => sql_condition)|| nil

    return @e
  end
end
