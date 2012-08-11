class PrjExpenseLogsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @prj_expense_logs  = PrjExpenseLog.paginate :page => params[:page], :per_page => 10
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
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @prj_expense_log = PrjExpenseLog.find(params[:id])
  end

  def update
    @prj_expense_log = PrjExpenseLog.find(params[:id])
    if @prj_expense_log.update_attributes(params[:prj_expense_log])
      flash[:notice] = 'PrjExpenseLog was successfully updated.'
      redirect_to :action => 'show', :id => @prj_expense_log
    else
      render :action => 'edit'
    end
  end

  def destroy
    PrjExpenseLog.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
