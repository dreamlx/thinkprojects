class ExpensesController < ApplicationController
  #filter_access_to :all
  # GET /expenses
  # GET /expenses.xml
  def index

    order_str =" expenses.updated_at desc "
    sql =" 1 "
    sql += " and expense_category like '%#{params[:expense_category].strip}%' "  if params[:expense_category].present?
    sql += " and projects.job_code like '%#{params[:job_code].strip}%' "  if params[:job_code].present?
    sql += " and clients.english_name like '%#{params[:client_name].strip}%' "  if params[:client_name].present?
    sql += " and charge_date <= '#{params[:end_date]}'" if params[:end_date].present?
    sql += " and charge_date >= '#{params[:start_date]}'" if params[:start_date].present?
    sql += " and expenses.person_id = #{params[:person_id]}" if params[:person_id].present?

    session[:expense_sql] =sql
    expenses = Expense.my_expenses(current_user.person_id, sql)
    @expenses = expenses.paginate(:page=> params[:page]||1)
    @sum_amount = 0
    expenses.each{|e| @sum_amount+=e.fee.to_f}


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
    @expense.reset
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

    render :update do |page|
      page.remove "item_#{params[:id]}"
      #page.replace_html 'flash_notice', "project was deleted"
    end
  end

  def approval
    expense = Expense.find(params[:id])
    expense.approval
    flash[:notice] = "Expense state was changed, current state is '#{expense.state}'"
    render :update do |page|
      page.replace_html "item_#{expense.id}", :partial => "item",:locals => { :expense => expense }
    end
  end

  def disapproval
    expense = Expense.find(params[:id])
    expense.disapproval
    flash[:notice] = "Expense state was changed, current state is '#{expense.state}'"
    render :update do |page|
      page.replace_html "item_#{expense.id}", :partial => "item",:locals => { :expense => expense }
    end
  end



end


