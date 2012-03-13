class ExpensesController < ApplicationController
  filter_access_to :all
  # GET /expenses
  # GET /expenses.xml
  def index
    
    order_str =" expenses.updated_at desc "
    sql =" 1 "
    sql += " and expense_category like '%#{params[:expense_category].strip}%' "  if params[:expense_category].present?
    #sql += " and projects.job_code like '%#{params[:job_code].strip}%' "  if params[:job_code].present?
    sql += " and project_id=#{params[:prj_id]}"       if params[:prj_id].present?
    sql += " and clients.english_name like '%#{params[:client_name].strip}%' "  if params[:client_name].present?
    sql += " and expenses.charge_date <= '#{format_date(params[:end_date])}'" if params[:end_date].present?
    sql += " and expenses.charge_date >= '#{format_date(params[:start_date])}'" if params[:start_date].present?
    sql += " and expenses.person_id = #{params[:person_id]}" if params[:person_id].present?
    sql += " and expenses.state = '#{params[:state]}'" if params[:state].present?
    
    if current_user.roles != 'providence_breaker'
      my_projects = Project.my_projects(current_user);
      ids= ''
      my_projects.each{|m| ids += m.id.to_s }
      sql += "and project_id in (#{ids})"
    end
    
    session[:expense_sql] =sql

    if current_user.roles == "providence_breaker"
      expenses = Expense.find(:all,:conditions=>sql, :order=>"expenses.state, projects.job_code",
      :joins=>" left join projects on project_id = projects.id left join clients on client_id = clients.id",
      :order=>'expenses.charge_date desc,expenses.state desc')
    else
      expenses = Expense.my_expenses(current_user.person_id, sql)

      if current_user.roles == 'staff' or current_user.roles == 'senior' or current_user.roles == 'manager'
        temp = expenses.map{|e| e.person_id == current_user.person_id ? e : nil}.compact
        expenses = temp
      end
    end

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

  def transform
    expense =    Expense.find(params[:source_id])
    if params[:target_id].present?
      @target_project = Project.find(params[:target_id])

      @t_message ="| Promotion code from: <#{expense.project.job_code}> to: <#{@target_project.job_code}>|"

      expense.desc += @t_message
      #@target_project.description += @t_message
      #personalcharge.project.save
      #@target_project.save
      #@target_project.personalcharges << personalcharge
      
      expense.project_id = params[:target_id]
      expense.save
    end
     respond_to do |format|
          flash[:notice] = 'Item was successfully forward.'
          format.html { redirect_to expenses_url }
          format.xml  { head :ok }
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
      page.insert_html :after, "item_#{expense.id}",:partial => "add_comment",:locals => { :item => expense }
    end
  end

  def batch_actions
    items = params[:check_items]
    unless items.nil?
      items.each{|key,value|
        p = Expense.find(value)
        case params[:do_action]
        when "approval":
          p.approval if p.state == "pending"
        when "disapproval":
          p.disapproval if p.state == "pending"
        when "destroy":
          p.destroy if p.state == "pending"

        else

        end
      }
    end

    redirect_to(:action=>"index")
  end
  def addcomment
    @expense = Expense.find(params[:id])
    comment = Comment.new(params[:comment])
    @expense.add_comment comment unless comment.nil?
    redirect_to expense_url(@expense) 

  end
  def format_date(get_date)
    if get_date.length <10
      arr = get_date.split('-')
      fdate = arr[0]
      (arr[1].length == 2) ? (fdate += "-#{arr[1]}") : (fdate += "-0#{arr[1]}")
      (arr[2].length == 2) ? (fdate += "-#{arr[2]}") : (fdate += "-0#{arr[2]}")
    else
      fdate= get_date
    end

    return fdate
  end
end


