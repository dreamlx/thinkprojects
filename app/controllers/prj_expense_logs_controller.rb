class PrjExpenseLogsController < ApplicationController
  def index
    @prj_expense_logs  = PrjExpenseLog.paginate(page: params[:page])
  end

  def show
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def new
    @prj_expense_log = PrjExpenseLog.new
  end

  def create
    @prj_expense_log = PrjExpenseLog.new(params[:prj_expense_log])
    if @prj_expense_log.save
      flash[:notice] = 'PrjExpenseLog was successfully created.'
      redirect_to @prj_expense_log
    else
      render 'new'
    end
  end

  def edit
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def update
    @prj_expense_log = PrjExpenseLog.find(params[:id])
    if @prj_expense_log.update_attributes(params[:prj_expense_log])
      flash[:notice] = 'PrjExpenseLog was successfully updated.'
      redirect_to @prj_expense_log
    else
      render 'edit'
    end
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to prj_expense_logs_path
  end
end
