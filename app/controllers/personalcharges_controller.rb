
class PersonalchargesController < ApplicationController
  def index
    sql = " 1 "
    sql += " and person_id=#{params[:person_id]}" if params[:person_id].present?
    if params[:period_from] == params[:period_to] and params[:period_from].present?
      sql += " and periods.number = '#{params[:period_from]}' "
      sql += " and periods.number  = '#{params[:period_to]}' "   
    else
      sql += " and periods.number >= '#{params[:period_from]}' "   if params[:period_from].present?
      sql += " and periods.number   <= '#{params[:period_to]}' "     if params[:period_to].present?
    end
    sql += " and project_id=#{params[:prj_id]}"       if params[:prj_id].present?
    sql2 = sql
    sql += " and personalcharges.state = '#{params[:state]}'" if params[:state].present?
    session[:personalcharge_sql]=sql
    page = params[:page]||1
    @personalcharges = Personalcharge.time_cost_paginate(current_user,sql,page,20)
    approved_condition = ""
    sql_ot =" select sum(hours) hours, personalcharges.user_id, personalcharges.period_id, personalcharges.project_id, personalcharges.charge_date charge_date from personalcharges 
    left join projects on personalcharges.project_id = projects.id 
    left join periods on personalcharges.period_id = periods.id
    where #{sql2}
    #{approved_condition}
    and charge_date is not null
    group by charge_date,user_id" 
    session[:personalcharge_ot] =sql_ot
    @approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
    @effective_hours = OverTime.remove_ineffective_hours(@approved_personalcharges)
    personalcharges = Personalcharge.my_personalcharges(current_user,sql)
    approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
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