class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  #
  auto_complete_for :client,:english_name
  auto_complete_for :project,:job_code

  #filter_access_to :all
  
  def index
    @project = Project.new(params[:project])
    @client = Client.new(params[:client])

    sql = ' 1 '
    sql += " and clients.english_name like '%#{@client.english_name}%' " if @client.english_name.present?
    sql += " and partner_id = #{@project.partner_id} " if @project.partner_id.present?
    sql += " and manager_id = #{@project.manager_id} " if @project.manager_id.present?
    sql += " and job_code like '%#{@project.job_code}%' " if @project.job_code.present?
    
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
    if current_user.roles == 'providence_breaker'
      projects = Project.find(:all, :conditions=>sql, :order=> order_str)
    else
      projects = Person.find(current_user.person_id).my_projects(sql,order_str)
    end
    @projects = projects.paginate(:page=>params[:page]||1)
    
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
    check_sum_hours
    
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
    render :update do |page|
      page.replace_html "item_#{project.id}", :partial => "item",:locals => { :project => project } 
    end
  end

  def disapproval
    project = Project.find(params[:id])
    project.disapproval
    flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
    render :update do |page|
      page.replace_html "item_#{project.id}", :partial => "item",:locals => { :project => project }
    end
  end
  
  def close
    project = Project.find(params[:id])
    #需要判断balance是否为0，如果有结余！=0 则无法close
   
    #allow_closed = check_closed(params[:id])
    if project.state == 'approved'
      project.close
    else
      project.approval
    end

    flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
    render :update do |page|
      page.replace_html "item_#{project.id}", :partial => "item",:locals => { :project => project }
    end

  end
  
  def transform

    @project =    Project.find(params[:id])
    if params[:zy_project][:id].present?
      @zy_project = Project.find(params[:zy_project][:id])
    
      @t_message = "<h3>Begin transfer</h3><br/>"
      @t_message +="==from #{@project.job_code} to #{@zy_project.job_code}==<hr/>"

      @project.bookings.each{|b|
        @zy_project.bookings<<b
        @t_message += " =>booking:No-#{b.id}, name-#{b.person.english_name}, hours-#{b.hours}<br/>"
      }

      @t_message +="<hr/>"
      @project.personalcharges.each{|p|
        @zy_project.personalcharges << p
        @t_message += " =>persnalcharges: No-#{p.id}, name-#{p.person.english_name}, hours-#{p.hours}, including ot hours-#{p.ot_hours}<br/>"
      }

      @t_message +="<hr/>"
      @project.expenses.each{|e|
        @zy_project.expenses << e
        @t_message += " =>expenses No-#{e.id}, category-#{e.expense_category}, fee -#{e.fee}<br/>"
      }
      @project.description += @t_message
    else
      @zy_project = nil
    end

    @project.close
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

  def check_sum_hours
    sum_hours = @project.bookings.sum('hours')
    sum_fee = 0
    for booking in @project.bookings
      sum_fee += (booking.hours * booking.person.charge_rate)
    end
    if @project.estimated_hours.to_i < sum_hours.to_i or @project.estimated_annual_fee.to_i < sum_fee.to_i
      flash[:notice] = 'booking超过预算请检查'
    end
  end

end
