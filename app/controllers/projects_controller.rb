#coding: utf-8

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  #
  # auto_complete_for :client,:english_name
  # auto_complete_for :project,:job_code

  ## filter_access_to :all
  
  def index
    @project = Project.new(params[:project])
    @client = Client.new(params[:client])

    sql = ' 1 '
    sql += " and clients.english_name like '%#{@client.english_name}%' " if @client.english_name.present?
    sql += " and bookings.person_id = #{params[:booking_id]} " if params[:booking_id].present?
    sql += " and job_code like '%#{@project.job_code}%' " if @project.job_code.present?
    sql += " and state = '#{params[:state]}'" if params[:state].present?
  
    if params[:order_by] == "job_code"
        order_str = "projects.job_code"
    elsif params[:order_by] == "created_on"
        order_str =" projects.created_on desc"
    elsif params[:order_by] == "client_name"
        order_str ="clients.english_name"
    else
      order_str = "projects.created_on desc"
    end
    
    projects = Project.my_projects(current_user,sql,order_str)
    @projects = Project.paginate(:page=>params[:page]||1)
    
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
    #check_sum_hours

    @bookings=@project.bookings

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
    @project = format_jobcode(@project)
    
    respond_to do |format|
      if @project.save
        @booking = Booking.new #项目创建者就是默认booking人员
        @booking.person_id = @project.manager_id
        @booking.project_id = @project.id
        @project.bookings<<@booking
        flash[:notice] = 'Project was successfully created.'
        #is_approval
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
    @project = format_jobcode(@project)
    
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
      page.insert_html :after, "item_#{project.id}",:partial => "add_comment",:locals => { :item => project }
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

    project =    Project.find(params[:source_id])
    if params[:target_id].present?
      @zy_project = Project.find(params[:target_id])

      @t_message ="|Promotion code from: <#{project.job_code}> to: <#{@zy_project.job_code}>"

      project.description += @t_message
      @zy_project.description += @t_message
      project.save
      @zy_project.save
      project.close
    else
      @zy_project = nil
    end
    respond_to do |format|
        flash[:notice] = 'Project was successfully forward.'
        format.html { redirect_to projects_url }
        format.xml  { head :ok }
    end
    
  end



  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy if @project.state == "pending"
    
    #respond_to do |format|
    #  format.html { redirect_to projects_url }
    #  format.xml  { head :ok }
    #end
    render :update do |page|
      page.remove "item_#{params[:id]}"
      #page.replace_html 'flash_notice', "project was deleted"
    end
  end
  

  def batch_actions
    items = params[:check_items]
    unless items.nil?
      items.each{|key,value|
        project = Project.find(value)
        case 
        when params[:do_action] == "approval"
            project.approval if project.state == "pending"
        when params[:do_action] == "disapproval"
            project.disapproval if project.state == "pending"
        when params[:do_action] == "destroy"
            project.destroy if project.state == "pending"
        when params[:do_action] == "close"
            project.close if project.state == "approved"
        else
    
        end
      }
    end

     redirect_to(request.env['HTTP_REFERER'] )
  end

  def addcomment
    project = Project.find(params[:id])
    comment = Comment.new(params[:comment])
    project.add_comment comment unless comment.nil?
    redirect_to project_url(project)

  end
  
  private

  def is_approval
    costing = @project.estimated_annual_fee - @project.budgeted_service_fee - @project.budgeted_expense

    @project.approval if costing> @project.estimated_annual_fee*25/100
  end

  def check_allow(project_id)

    billings = Billing.where(:conditions => "project_id = #{project_id}")
    billing_number= "<br/>|need close billings --"
    for item in billings
      billing_number = (billing_number + item.number + " |") if item.status.to_s == 0.to_s
    end
  end

  def check_sum_hours
    sum_hours = @project.bookings.sum('hours')
    sum_fee = 0
    for booking in @project.bookings
      unless booking.person.nil?
        sum_fee += (booking.hours * booking.person.charge_rate||0)
      end
    end
    if @project.estimated_hours.to_i < sum_hours.to_i or @project.estimated_annual_fee.to_i < sum_fee.to_i
      flash[:notice] = 'booking超过预算请检查'
    end
  end

  def format_jobcode(project)
    unless project.job_code.present?
      project.job_code =project.client.client_code+project.GMU.code+project.service_code.code
    end

    project.job_code = project.job_code.upcase

    return project
  end
end
