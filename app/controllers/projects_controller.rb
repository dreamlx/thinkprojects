class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  #
  auto_complete_for :client,:english_name
  auto_complete_for :project,:job_code

  filter_access_to :all
  
  def index
    @project = Project.new(params[:project])
    @client = Client.new(params[:client])

    sql = ' 1 '
    sql += " and clients.english_name like '%#{@client.english_name}%' " if @client.english_name.present?
    sql += " and partner_id = #{@project.partner_id} " unless @project.partner_id == 0 or @project.partner_id.nil?
    sql += " and manager_id = #{@project.manager_id} " unless @project.manager_id == 0 or @project.manager_id.nil?
    sql += " and job_code like '%#{@project.job_code}%' " if @project.job_code.present?
    sql += " and manager_id = #{current_user.person_id} " if current_user.roles =='manager'
    sql += " and state = '#{params[:state]}'" if params[:state].present?

    case params[:order_by]
    when "job_code":
        order_str = "projects.job_code"
    when "created_on":
        order_str =" projects.created_on desc"
    when "client_name":
        order_str ="clients.english_name"
    else
      order_str = "projects.created_on desc"
    end
    @projects = Project.search_by_sql(sql,params[:page],order_str)
        
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @projects.to_xml }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @booking = Booking.new
    sum_hours = @project.bookings.sum('hours')
    sum_fee = 0
    for booking in @project.bookings
      sum_fee += (booking.hours * booking.person.charge_rate)
    end
    if @project.estimated_hours.to_i < sum_hours.to_i or @project.estimated_annual_fee.to_i < sum_fee.to_i
      flash[:notice] = 'booking超过预算请检查'
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @project.to_xml }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1;edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    if @project.job_code == nil or @project.job_code ==""                       
      @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code
    end
    
    respond_to do |format|
      if @project.save
       
        flash[:notice] = 'Project was successfully created.'
        is_approval
        format.html { redirect_to project_url(@project) }
        format.xml  { head :created, :location => project_url(@project) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    if @project.job_code.nil? or @project.job_code.blank?                      
      @project.job_code =@project.client.client_code+@project.GMU.code+@project.service_code.code
    end
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        
        @project.reset
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to project_url(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors.to_xml }
      end
    end
  end

  def approval
    project = Project.find(params[:id])
    project.approval
    
    flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
    respond_to do |format|

        format.html { redirect_to projects_url }
        format.xml  { head :ok }
      end
  end

  def disapproval
    project = Project.find(params[:id])
    project.disapproval
    flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
    render :update do |page|
      page.replace_html "item_#{params[:id]}", :partial => "item",:locals => { :project => project }
    end
  end
  
  def close
    project = Project.find(params[:id])
    #需要判断balance是否为0，如果有结余！=0 则无法close
    #allow_closed = is_balance(Project.find(params[:id]),Period.today_period)
    #allow_closed = check_closed(params[:id])
   
    project.close 

     #if allow_closed
     #   flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
     # else
     #   flash[:notice] = billing_number
     # end

    render :update do |page|
      page.replace_html "item_#{project.id}", :partial => "item",:locals => { :project => project }
    end
  end
  
     

  def transform    

    @project =    Project.find(params[:id])
    
    @project.id = nil
    @project.job_code[0,2] = 'ZY'

    @project.reset
    respond_to do |format|
      
      format.html { render :action => "new" }
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    
    #respond_to do |format|
    #  format.html { redirect_to projects_url }
    #  format.xml  { head :ok }
    #end
    render :update do |page|
      page.remove "item_#{params[:id]}"
      #page.replace_html 'flash_notice', "project was deleted"
    end
  end
  

  private

  def is_approval
    costing = @project.estimated_annual_fee - @project.budgeted_service_fee - @project.budgeted_expense

    @project.approval if costing> @project.estimated_annual_fee*25/100
  end

  def check_allow(project_id)

    billings = Billing.find(:all,:conditions => "project_id = #{project_id}")
    billing_number= "<br/>|need close billings --"
    for item in billings
      billing_number = (billing_number + item.number + " |") if item.status.to_s == 0.to_s
    end


  end

end
