class ExpensesController < ApplicationController
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

    session[:expense_sql] =sql
    @expenses = Expense.my_expenses(current_user, sql).paginate(:page=> params[:page]||1)
    @sum_amount = @expenses.sum("fee")
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def new
    @expense = Expense.new
    @expense.project_id = params[:prj_id]
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def create
    @expense = Expense.new(params[:expense])

    if @expense.save
      flash[:notice] = 'Expense was successfully created.'
      redirect_to @expense
    else
      render "new"
    end
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.reset
    if @expense.update_attributes(params[:expense])

      flash[:notice] = 'Expense was successfully updated.'
      redirect_to @expense
    else
      render  "edit"
    end
  end

  def destroy
    Expense.find(params[:id]).destroy
    redirect_to expenses_url
  end

  def transform
    expense = Expense.find(params[:source_id])
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
    #expense.approved_by = session[:user_id] 
    expense.approval
    flash[:notice] = "Expense state was changed, current state is '#{expense.state}'"
    render :update do |page|
      page.replace_html "item_#{expense.id}", :partial => "item",:locals => { :expense => expense }
    end
  end

  def disapproval
    expense = Expense.find(params[:id])
    expense.approved_by = nil 
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
        case 
        when params[:do_action] == "approval"
          p.approval if p.state == "pending"
        when params[:do_action] == "disapproval"
          p.disapproval if p.state == "pending"
        when params[:do_action] == "destroy"
          p.destroy if p.state == "pending"
        end
      }
    end

    #redirect_to(:action=>"index")
    redirect_to(request.env['HTTP_REFERER'] )
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