class ReceiveAmountsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_billing
  def edit
    @receive_amount = ReceiveAmount.find(params[:id])
  end

  def create
    # @receive_amount = @billing.receive_amounts.build(params[:receive_amount])
    @receive_amount = @billing.receive_amounts.build(receive_amount_params)
    if @receive_amount.save
      redirect_to @billing, notice: 'ReceiveAmount was successfully created.'
    else
      render 'new'
    end
  end

  def update
    @receive_amount = ReceiveAmount.find(params[:id])
    # if @receive_amount.update_attributes(params[:receive_amount])
    if @receive_amount.update_attributes(receive_amount_params)
      redirect_to billing_url(@billing), notice: 'ReceiveAmount was successfully updated.'
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

    def receive_amount_params
      params.require(:receive_amount).permit(:created_on, :updated_on, :invoice_no, :receive_date, :receive_amount)
    end
end
