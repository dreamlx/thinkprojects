class ReceiveAmountsController < ApplicationController
  before_filter :set_billing
  def edit
    @receive_amount = ReceiveAmount.find(params[:id])
  end

  def create
    @receive_amount = @billing.receive_amounts.build(params[:receive_amount])
    if @receive_amount.save
      flash[:notice] = 'ReceiveAmount was successfully created.'
      redirect_to @billing
    else
      render 'new'
    end
  end

  def update
    @receive_amount = ReceiveAmount.find(params[:id])
    if @receive_amount.update_attributes(params[:receive_amount])
      flash[:notice] = 'ReceiveAmount was successfully updated.'
      redirect_to billing_url(@billing)
    else
      render :action => 'edit'
    end
  end

  def destroy
    ReceiveAmount.find(params[:id]).destroy
    redirect_to billing_url(@billing)
  end

  private
    def set_billing
      @billing = Billing.find(params[:billing_id])
    end
end
