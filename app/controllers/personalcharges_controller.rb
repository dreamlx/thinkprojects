class PersonalchargesController < ApplicationController
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.includes(:period, :project).paginate(:page => params[:page])
  end

  def new
    @personalcharge = Personalcharge.new
  end

  def show
    @personalcharge = Personalcharge.find(params[:id])
  end

  def create
    @personalcharge = Personalcharge.new(params[:personalcharge])
    @personalcharge.service_fee = @personalcharge.hours * @personalcharge.user.charge_rate if @personalcharge.user.charge_rate
    if @personalcharge.save
      redirect_to @personalcharge
    else
      render "new"
    end
  end

  def edit   
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])
    if @personalcharge.update_attributes(params[:personalcharge])
      @personalcharge.reload
      @personalcharge.service_fee = @personalcharge.hours * @personalcharge.user.charge_rate if @personalcharge.user.charge_rate
      @personalcharge.save
      redirect_to @personalcharge, notice: 'Personalcharge was successfully updated.'
    else
      render "edit"
    end
  end

  def destroy
    Personalcharge.find(params[:id]).destroy 
    redirect_to personalcharges_url
  end

  def get_ot
    sql_ot = session[:personalcharge_ot]
    @approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
    @effective_hours = OverTime.remove_ineffective_hours(@approved_personalcharges)
    @standard_hours = OverTime.standard_hours(@approved_personalcharges)
    @ot_hours       = OverTime.ot_hours(@effective_hours) 
    @ot_pay_hours   = OverTime.ot_pay_hours(@effective_hours) 
  end

  def addcomment
    @personalcharge = Personalcharge.find(params[:id])
    comment = Comment.new(params[:comment])
    @personalcharge.add_comment comment if comment
    redirect_to @personalcharge 
  end

  def transform
    personalcharge =    Personalcharge.find(params[:source_id])
    if params[:target_id].present?
      @target_project = Project.find(params[:target_id])
      @t_message ="| Promotion code from: <#{personalcharge.project.job_code}> to: <#{@target_project.job_code}> |"
      personalcharge.desc = "" if personalcharge.desc.nil?
      personalcharge.desc += @t_message
      personalcharge.project_id = params[:target_id]
      personalcharge.save
    end
    redirect_to personalcharges_url, notice: 'Item was successfully forward.'
  end

  def approval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.approval
    redirect_to personalcharges_url, notice: "state was changed, current state is '#{personalcharge.state}'"
  end
  
  def disapproval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.disapproval
    flash[:notice] = " state was changed, current state is '#{personalcharge.state}'"
    redirect_to personalcharges_url
  end
end