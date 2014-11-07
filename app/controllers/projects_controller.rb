#coding: utf-8
class ProjectsController < ApplicationController
  def index
    @q = Project.search(params[:q])
    @projects = @q.result.includes(:client).paginate(:page => params[:page])
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
    @project.job_code = @project.client.client_code + 
                        Dict.find(@project.GMU_id).code + 
                        @project.service_code.code
    @project.bookings.build(user_id: current_user.id)
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to @project
    else
      render "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    
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
    redirect_to projects_path, notice: notice_message(project.job_code, project.state)
  end

  def disapproval
    project = Project.find(params[:id])
    project.disapproval
    redirect_to projects_path, notice: notice_message(project.job_code, project.state)
  end
  
  def close
    project = Project.find(params[:id])
    if project.state == 'approved'
      project.close
    else
      project.approval
    end
    redirect_to projects_path, notice: notice_message(project.job_code, project.state)
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

  def addcomment
    project = Project.find(params[:id])
    comment = Comment.new(params[:comment])
    project.add_comment comment unless comment.nil?
    redirect_to project_url(project)
  end

  private
    def notice_message(job_code, state)
      "Project <#{job_code}> state was changed, current state is '#{state}'"
    end
end