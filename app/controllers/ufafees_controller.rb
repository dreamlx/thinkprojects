class UfafeesController < ApplicationController
auto_complete_for :ufafee, :number
  def index
    list
    render :action => 'list'
  end


  def list
  	sql = ' 1 '
  	if !request.get?
  		sql +=" and number like '%#{params[:ufafee][:number]}%' "
  	end
  	
    @ufafees  = Ufafee.paginate :page => params[:page], :per_page => 10,:conditions=>sql
  end

  def show
    @ufafee = Ufafee.find(params[:id])
  end

  def new
    init_set  
    billing_number_set
    @ufafee = Ufafee.new
    @ufafee.number = @billing_number.title + @str_number
  end

  def create
    @billing_number = Dict.find(:first, :conditions =>" category ='billing_number' ")
    @number = @billing_number.code.to_i + 1
    @billing_number.code = @number.to_s
    @billing_number.save  
    @ufafee = Ufafee.new(params[:ufafee])
    get_amount
    if @ufafee.save
      flash[:notice] = 'Ufafee was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    init_set  
    @ufafee = Ufafee.find(params[:id])
  end

  def update
    @ufafee = Ufafee.find(params[:id])
    if @ufafee.update_attributes(params[:ufafee])
    get_amount
    @ufafee.save
      flash[:notice] = 'Ufafee was successfully updated.'
      redirect_to :action => 'show', :id => @ufafee
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ufafee.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private
    def get_amount
    @ufafee.amount = @ufafee.service_UFA + @ufafee.expense_UFA
  end
end
