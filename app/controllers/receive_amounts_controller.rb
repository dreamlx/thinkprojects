class ReceiveAmountsController < ApplicationController
  def index
    list
    render :action => 'list'
  end


  def list
    @receive_amounts  = ReceiveAmount.paginate :page => params[:page], :per_page => 30
  end

  def show
    @receive_amount = ReceiveAmount.find(params[:id])
  end

  def new
    @billing = Billing.find(params[:id])
    @receive_amount = ReceiveAmount.new
  end

  def create
    @receive_amount = ReceiveAmount.new(params[:receive_amount])
    if @receive_amount.save
      flash[:notice] = 'ReceiveAmount was successfully created.'
      redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id
    else
      render 'new'
    end
  end

  def edit 
    @receive_amount = ReceiveAmount.find(params[:id])
    @billing = Billing.find(@receive_amount.billing_id)
  end

  def update
    @receive_amount = ReceiveAmount.find(params[:id])
    if @receive_amount.update_attributes(params[:receive_amount])
      flash[:notice] = 'ReceiveAmount was successfully updated.'
      redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    @receive_amount=ReceiveAmount.find(params[:id])
    ReceiveAmount.find(params[:id]).destroy
    redirect_to :controller => 'billings', :action =>'show', :id => @receive_amount.billing_id
  end
end
