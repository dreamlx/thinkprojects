class ExpensesController < ApplicationController
  filter_access_to :all
  # GET /expenses
  # GET /expenses.xml
  def index
    #prj_id = params[:prj_id]
    @col_lists  = %w[commission outsourcing tickets courrier postage stationery report_binding cash_advance payment_on_be_half ]
    @col_list   = params[:col_list]
    
    @expense = Expense.new(params[:expense])
    @expense.project_id = params[:prj_id] unless params[:prj_id].blank?
    @period_from = Expense.new(params[:period_from])
    @period_to = Expense.new(params[:period_to])
    @col_list = params[:col_list]
    
    #@current_period = get_now_period
    #["project_id=? and period_id = ?",params[:id], @current_period.id ]

    str_order =" periods.number desc,expenses.updated_on desc "
    sql =" 1 "
    #    unless (prj_id.nil? or prj_id.blank?)
    #      sql += " and project_id = #{prj_id} "
    #    end

    
    sql += " and project_id =#{ @expense.project_id} " unless @expense.project_id.nil?
     sql += " and memo like '%#{ @expense.memo}%' " unless @expense.memo.nil?
    sql += " and periods.number >='#{ @period_from.period.number}' " unless (@period_from.period_id.nil? or @period_from.period.nil?)
    sql += " and periods.number <='#{ @period_to.period.number}' " unless (@period_to.period_id.nil? or @period_to.period.nil?)
    sql += " and not #{@col_list} = 0 " if @col_list != "" and @col_list != nil
    @temp = sql
    @sum_expense = Expense.new
    @sum_expense.cash_advance = Expense.sum(:cash_advance,:include => :period,:conditions=>sql)
    @sum_expense.commission = Expense.sum(:commission,:include => :period,:conditions=>sql)
    @sum_expense.courrier = Expense.sum(:courrier,:include => :period,:conditions=>sql)
    @sum_expense.outsourcing = Expense.sum(:outsourcing,:include => :period,:conditions=>sql)
    @sum_expense.payment_on_be_half = Expense.sum(:payment_on_be_half,:include => :period,:conditions=>sql)
    @sum_expense.postage = Expense.sum(:postage,:include => :period,:conditions=>sql)
    @sum_expense.report_binding = Expense.sum(:report_binding,:include => :period,:conditions=>sql)
    @sum_expense.stationery = Expense.sum(:stationery,:include => :period,:conditions=>sql)
    @sum_expense.tickets = Expense.sum(:tickets,:include => :period,:conditions=>sql)
    @expenses = Expense.paginate  :page => params[:page],
      :per_page => 20,
      :order=>str_order,
      :include => :period,
      :conditions => sql
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @expenses.to_xml }
    end
  end

  # GET /expenses/1
  # GET /expenses/1.xml
  def show
    @expense = Expense.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @expense.to_xml }
    end
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @expense.project_id = params[:prj_id]
    @expense.period_id = Period.find(:first, :order=>" number desc").id
  end

  # GET /expenses/1;edit
  def edit
    @expense = Expense.find(params[:id])
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    @expense = Expense.new(params[:expense])

    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Expense was successfully created.'
        format.html { redirect_to expense_url(@expense) }
        format.xml  { head :created, :location => expense_url(@expense) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expense.errors.to_xml }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.xml
  def update
    @expense = Expense.find(params[:id])

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        flash[:notice] = 'Expense was successfully updated.'
        format.html { redirect_to expense_url(@expense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors.to_xml }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.xml
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.xml  { head :ok }
    end
  end
end
