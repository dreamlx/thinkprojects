
class PersonalchargesController < ApplicationController
  def index
    @q = Personalcharge.search(params[:q])
    @personalcharges = @q.result.includes(:period, :project).paginate(:page => params[:page])
  end

  def new
    @personalcharge = Personalcharge.new
    @personalcharge.user_id = params[:user_id] if  params[:user_id]
    @personalcharge.project_id = params[:id] if  params[:id]
  end

  def show
    @personalcharge = Personalcharge.find(params[:id])
  end

  def create
    @personalcharge = Personalcharge.new(params[:personalcharge])
    @personalcharge.service_fee = @personalcharge.hours * @personalcharge.user.charge_rate
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
      @personalcharge.reset
      flash[:notice] = 'Personalcharge was successfully updated.'
      @personalcharge.service_fee = @personalcharge.hours * @personalcharge.user.charge_rate
      @personalcharge.save
      redirect_to @personalcharge
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
      #@target_project.description += @t_message
      #personalcharge.project.save
      #@target_project.save
      #@target_project.personalcharges << personalcharge

      personalcharge.project_id = params[:target_id]
      personalcharge.save
    end
    respond_to do |format|
      flash[:notice] = 'Item was successfully forward.'
      format.html { redirect_to personalcharges_url }
      format.xml  { head :ok }
    end 
  end

  def approval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.approval
    flash[:notice] = " state was changed, current state is '#{personalcharge.state}'"
    redirect_to personalcharges_url
  end
  
  def disapproval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.disapproval
    flash[:notice] = " state was changed, current state is '#{personalcharge.state}'"
    redirect_to personalcharges_url
  end

  def batch_actions
    items = params[:check_items]
    if items
      items.each do |key,value|
        p = Personalcharge.find(value)
        case 
        when params[:do_action] == "approval"
          p.approval if p.state == "pending"
        when params[:do_action] == "disapproval"
          p.disapproval if p.state == "pending"
        when params[:do_action] == "destroy"
          p.destroy if p.state == "pending"
        end
      end
    end
    redirect_to(request.env['HTTP_REFERER'] )
  end

  private
    def get_now_period
      @cookie_value = cookies[:the_time]
      if @cookie_value != ""
        sql_condition  = " id = '#{@cookie_value}'"
      else
        sql_condition = "id = 0"
      end
      @now_period = Period.where(sql_condition).first
    end
end