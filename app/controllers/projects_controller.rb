#coding: utf-8
class ProjectsController < ApplicationController
  load_and_authorize_resource
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
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.json { respond_with_bip(@project) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@project) }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy if @project.state == "pending"
    redirect_to projects_url
  end

  def approval
    project = Project.find(params[:id])
    project.comments.create(comment: 'approve the project', user_id: current_user.id)
    project.approval
    redirect_to project, notice: notice_message(project.job_code, project.state)
  end

  def disapproval
    project = Project.find(params[:id])
    project.comments.create(comment: 'disapprove the project', user_id: current_user.id)
    project.disapproval
    redirect_to project, notice: notice_message(project.job_code, project.state)
  end
  
  def close
    project = Project.find(params[:id])
    project.comments.create(comment: 'close the project', user_id: current_user.id)
    project.close
    redirect_to project, notice: notice_message(project.job_code, project.state)
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
    redirect_to projects_url, notice: 'Project was successfully forward.'
  end

  private
    def notice_message(job_code, state)
      "Project <#{job_code}> state was changed, current state is '#{state}'"
    end

    def project_params
      params.require(:project).permit(:job_code, :state, :client_id, :manager_id,
                                      :GMU_id, :description, :service_id, :starting_date, :ending_date, 
                                      :estimated_annual_fee, :estimated_hours, :budgeted_service_fee, :budgeted_expense)
    end
end