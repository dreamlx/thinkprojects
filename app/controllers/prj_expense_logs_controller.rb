class PrjExpenseLogsController < ApplicationController
  load_and_authorize_resource
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
    # @prj_expense_log = PrjExpenseLog.new(params[:prj_expense_log])
    @prj_expense_log = PrjExpenseLog.new(prj_expense_log_params)
    if @prj_expense_log.save
      redirect_to @prj_expense_log, notice: 'PrjExpenseLog was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def update
    @prj_expense_log = PrjExpenseLog.find(params[:id])
    # if @prj_expense_log.update_attributes(params[:prj_expense_log])
    if @prj_expense_log.update_attributes(prj_expense_log_params)
      redirect_to @prj_expense_log, notice: 'PrjExpenseLog was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to prj_expense_logs_path
  end

  private
    def prj_expense_log_params
      params.require(:prj_expense_log).permit(:other)
    end
end
