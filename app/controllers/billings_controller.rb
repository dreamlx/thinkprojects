class BillingsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Billing.search(params[:q])
    @billings = @q.result.includes(:project).paginate(page: params[:page])
  end

  def show
    @billing = Billing.find(params[:id])
    @receive_amount = ReceiveAmount.new
    @receive_amounts = ReceiveAmount.where(billing_id: @billing.id)
    if @billing.status != '1'
      @billing_amount = ReceiveAmount.sum('receive_amount', :conditions =>['billing_id = ?', @billing.id ])||0
      @billing.outstanding = @billing.amount - @billing_amount
      Billing.update(@billing.id,{:outstanding =>@billing.outstanding})
      if @billing_amount == @billing.amount
        @billing.status = '1'
        Billing.update(@billing.id,{:status =>'1'})
      else
        @billing.status = '0'
        Billing.update(@billing.id,{:status =>'0'})      
      end
    else
      @billing.outstanding =0
      Billing.update(@billing.id,{:outstanding =>@billing.outstanding})
    end
  end

  def new
    billing_number_set
    @type = Dict.where(category: "billing_type")
    @billing = Billing.new  
    @billing.number = @billing_number.title + @str_number
    @now_period = get_now_period
    @billing.period_id = @now_period.id
    @billing.days_of_ageing = 0
    @billing.write_off = 0
    @billing.provision = 0
  end

  def create
    @billing = Billing.new(params[:billing])
    @billing_number = Dict.where(category: 'billing_number').first
    @number = @billing_number.code.to_i + 1
    @billing_number.code = @number.to_s
    update_collection_days
    get_tax
    get_amount
    @billing.outstanding = @billing.amount
    if @billing.save
      flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
      redirect_to @billing
    else
      render "new"
    end
  end

  def edit
    @type = Dict.where("category ='billing_type'")
    @billing = Billing.find(params[:id])
  end

  def update
    @billing = Billing.find(params[:id])
    if @billing.update_attributes(params[:billing])
      flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
      get_tax
      get_amount
      outstanding_net=  @billing.outstanding - @billing.write_off
      if outstanding_net == 0
        @billing.status = '1'
      end
      update_collection_days
      @billing.save
      redirect_to billing_url(@billing)
    else
      render "edit"
    end
  end

  def destroy
    Billing.find(params[:id]).destroy
    redirect_to billings_url
  end

  private 
    def get_cookie
      @cookie_value = cookies[:the_time]
    end
    
    def get_tax
      tax_rate = 5.26/100
      @billing.business_tax = @billing.service_billing * tax_rate
    end
    
    def get_amount
      @billing.amount = @billing.service_billing + @billing.expense_billing
    end
    
    def update_collection_days
      if @billing.status == "1"
        @billing.collection_days = @billing.days_of_ageing
        @billing.outstanding =@billing.amount
      end
    end

    def get_now_period
      cookie_period_id = cookies[:the_time]
      if cookie_period_id != ""
        sql_condition  = " id = '#{cookie_period_id}'"
      else
        sql_condition = "id = 0"
      end
      now_period = Period.where(sql_condition ).first || Period.today_period

    end

    def billing_number_set
      @billing_number = Dict.find_by_category(:billing_number)
      @number = @billing_number.code.to_i + 1

      case @number
      when @number <10
        @str_number = "000" + @number.to_s
      when @number <100
        @str_number = "00" + @number.to_s
      when @number <1000
        @str_number = "0" + @number.to_s
      when
        @str_number = @number.to_s
      end
    end
end
