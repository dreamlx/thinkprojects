class BillingsController < ApplicationController
  filter_access_to :all
  def index
    #list
    #render :action => 'list'

    @billing = Billing.new(params[:billing])
    @period = Period.new(params[:period])

    sql = ' 1 '
    sql+= " and project_id = #{@billing.project_id}" unless @billing.project_id.blank? or @billing.project_id == 0
    sql+= " and number like '#{@billing.number}%'" unless @billing.number.blank?
    sql+= " and status = 0"  if @billing.status == 'outstanding'
    sql+= " and status =1"  if @billing.status == 'received'

    
    sql += " and billing_date <= '#{@period.ending_date}'"  unless @period.ending_date.blank?
    sql += " and billing_date >= '#{@period.starting_date}'  " unless @period.starting_date.blank?

    @billings  = Billing.paginate :page => params[:page],
      :per_page => 20,
      :conditions =>sql
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @billings.to_xml }
    end
  end

  def show
    @billing = Billing.find(params[:id])
    @receive_amounts = ReceiveAmount.find(:all, :conditions=>['billing_id = ?',@billing.id])
   
    if @billing.status != '1'
      @billing_amount = ReceiveAmount.sum('receive_amount', :conditions =>['billing_id = ?', @billing.id ])||0
      #Billing.update(@billing.id, {:amount=>@billing.amount})
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
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @billing.to_xml }
    end

  end

  def new
    init_set
    billing_number_set
    @type = Dict.find(:all, :conditions => "category ='billing_type'")
    @billing = Billing.new
    #@periods = Period.find(:all)
    
    @billing.number = @billing_number.title + @str_number
    @now_period = get_now_period
    @billing.period_id = @now_period.id
    @billing.days_of_ageing = 0
    @billing.write_off = 0
    @billing.provision = 0
  end

  def create
    @billing = Billing.new(params[:billing])
    @billing_number = Dict.find(:first, :conditions =>" category ='billing_number' ")
    @number = @billing_number.code.to_i + 1
    @billing_number.code = @number.to_s
        
    update_collection_days
    get_tax
    get_amount
    @billing.outstanding = @billing.amount


    respond_to do |format|
      if @billing.save

        flash[:notice] = @billing.project.job_code + ' -- Billing was successfully updated.'
        format.html { redirect_to billing_url(@billing) }
        format.xml  { head :created, :location => billing_url(@billing) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billing.errors.to_xml }
      end
      
    end

  end

  def edit
    init_set
    @type = Dict.find(:all, :conditions => "category ='billing_type'")
    
    @billing = Billing.find(params[:id])

  end

  def update
    @billing = Billing.find(params[:id])
    respond_to do |format|
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
        format.html { redirect_to billing_url(@billing) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @billing.errors.to_xml }
      end
    end


  end

  def destroy
    Billing.find(params[:id]).destroy


    respond_to do |format|
      format.html { redirect_to billings_url }
      format.xml  { head :ok }
    end
  end


  private
  
  def get_cookie
    @cookie_value = cookies[:the_time]
    #render(:action=>index,:text =>" #{cookie_value}")
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
end
