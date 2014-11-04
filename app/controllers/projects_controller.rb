#coding: utf-8
class ProjectsController < ApplicationController
  def index
    @projects = Project.paginate(:page => params[:page])
  end

  def show
    @project = Project.find(params[:id])
    @booking = Booking.new
    @bookings=@project.bookings
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    @project = format_jobcode(@project)
    if @project.save
      @booking = Booking.new #项目创建者就是默认booking人员
      @booking.user_id = @project.manager_id
      @booking.project_id = @project.id
      @project.bookings<<@booking
      flash[:notice] = 'Project was successfully created.'
      redirect_to @project
    else
      render "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    @project = format_jobcode(@project)
    
    if @project.update_attributes(params[:project])        
      @project.reset
      flash[:notice] = 'Project was successfully updated.'
      redirect_to @project
    else
      render "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy if @project.state == "pending"
    redirect_to projects_url
  end

  def approval
    project = Project.find(params[:id])
    project.approval

    flash[:notice] = "Project <#{project.job_code}> state was changed, current state is '#{project.state}'"
    redirect_to projects_path
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
    project = Project.find(params[:source_id])
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
    flash[:notice] = 'Project was successfully forward.'
    redirect_to projects_url
  end
  
  def batch_actions
    items = params[:check_items]
    if items
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
      billings.each do |item|
        billing_number = (billing_number + item.number + " |") if item.status.to_s == 0.to_s
      end
    end

    def check_sum_hours
      sum_hours = @project.bookings.sum('hours')
      sum_fee = 0
      @project.bookings.each do |booking|
        sum_fee += (booking.hours * booking.person.charge_rate||0) if booking.person
      end
      if @project.estimated_hours.to_i < sum_hours.to_i or @project.estimated_annual_fee.to_i < sum_fee.to_i
        flash[:notice] = 'booking超过预算请检查'
      end
    end

    def format_jobcode(project)
      project.job_code =project.client.client_code+Dict.find(project.GMU_id).code+project.service_code.code if project.job_code
      project.job_code = project.job_code.upcase
      return project
    end
end
