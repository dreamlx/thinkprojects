class ExpensesController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Expense.search(params[:q])
    @expenses = @q.result.includes(:user, :project).paginate(:page=> params[:page])
    @sum_amount = @expenses.sum("fee")
    expenses = current_user.expenses
    respond_to do |format|
      format.html
      format.xls { send_data expenses.to_xls,:filename=>"expenses.xls", :disposition => 'attachment' }
    end  
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
      redirect_to @expense, notice: 'Expense was successfully created.'
    else
      render "new"
    end
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.reset
    if @expense.update_attributes(params[:expense])
      redirect_to @expense, notice: 'Expense was successfully updated.'
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
      expense.project_id = params[:target_id]
      expense.save
    end
    redirect_to expenses_url, notice: 'Item was successfully forward.'
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

  def addcomment
    @expense = Expense.find(params[:id])
    comment = Comment.new(params[:comment])
    @expense.add_comment comment unless comment.nil?
    redirect_to expense_url(@expense) 

  end
end