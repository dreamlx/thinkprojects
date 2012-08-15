
class PersonalchargesController < ApplicationController
  filter_access_to :all
  #caches_action :index

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)

  def index
    sql = " 1 "
    sql += " and person_id=#{params[:person_id]}"     if params[:person_id].present?

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

    #personalcharges = Personalcharge.my_personalcharges(current_user,sql)

    session[:personalcharge_sql]=sql
    #@personalcharges = personalcharges.paginate(:page=>params[:page]||1)
    page = params[:page]||1
    @personalcharges = Personalcharge.time_cost_paginate(current_user,sql,page,20)
    #OT 参考 over ti
    sql_ot =" select sum(hours) hours, personalcharges.person_id, personalcharges.period_id, personalcharges.project_id, personalcharges.charge_date charge_date from personalcharges 
    left join projects on personalcharges.project_id = projects.id 
    left join periods on personalcharges.period_id = periods.id

    where #{sql2}
    and personalcharges.state = 'approved' and charge_date is not null
    group by charge_date,person_id
    " 
    session[:personalcharge_ot] =sql_ot
    @approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
    
    @effective_hours = OverTime.remove_ineffective_hours(@approved_personalcharges)
    #session[:approved_personalcharges] =@approved_personalcharges
    #session[:effective_hours] = @effective_hours
    #@standard_hours = OverTime.standard_hours(approved_personalcharges)
    #@ot_hours       = OverTime.ot_hours(effective_hours)
    #@ot_pay_hours   = OverTime.ot_pay_hours(effective_hours)
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @personalcharges.to_xml }
    end

    #caching
    personalcharges = Personalcharge.my_personalcharges(current_user,sql)
    approved_personalcharges = Personalcharge.find_by_sql(sql_ot)
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
    @personalcharge.add_comment comment unless comment.nil?
    redirect_to personalcharge_url(@personalcharge) 
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

  def show
    @personalcharge = Personalcharge.find(params[:id])
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @personalcharge.to_xml }
    end
  end

  def new

    @personalcharge = Personalcharge.new
    if not params[:person_id].nil?
      @personalcharge.person_id = params[:person_id]
    end
    if not params[:id].nil?
      @personalcharge.project_id = params[:id]
    end

  end

  def approval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.approval

    flash[:notice] = " state was changed, current state is '#{personalcharge.state}'"
    render :update do |page|
      page.replace_html "item_#{personalcharge.id}", :partial => "item",:locals => { :personalcharge => personalcharge }
    end
  end

  def disapproval
    personalcharge = Personalcharge.find(params[:id])
    personalcharge.state= "pending" if personalcharge.state.nil?
    personalcharge.disapproval
    flash[:notice] = " state was changed, current state is '#{personalcharge.state}'"
    render :update do |page|
      page.replace_html "item_#{personalcharge.id}", :partial => "item",:locals => { :personalcharge => personalcharge }
      page.insert_html :after, "item_#{personalcharge.id}",:partial => "add_comment",:locals => { :item => personalcharge }
    end
  end

  def create
    @personalcharge = Personalcharge.new(params[:personalcharge])
    person = Person.find(@personalcharge.person_id)
    @personalcharge.service_fee = @personalcharge.hours * person.charge_rate
    respond_to do |format|
      if @personalcharge.save
        format.html { redirect_to personalcharge_url(@personalcharge) }
        format.xml  { head :created, :location => personalcharge_url(@personalcharge) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personalcharge.errors.to_xml }
      end
    end
  end

  def edit   
    @personalcharge = Personalcharge.find(params[:id])
  end

  def update
    @personalcharge = Personalcharge.find(params[:id])

    respond_to do |format|
      if @personalcharge.update_attributes(params[:personalcharge])
        @personalcharge.reset
        flash[:notice] = 'Personalcharge was successfully updated.'
        person = Person.find(@personalcharge.person_id)
        @personalcharge.service_fee = @personalcharge.hours * person.charge_rate
        @personalcharge.save
        format.html { redirect_to personalcharge_url(@personalcharge) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personalcharge.errors.to_xml }
      end
    end
  end

  def destroy
    Personalcharge.find(params[:id]).destroy 
    render :update do |page|
      page.remove "item_#{params[:id]}"
    end
  end

  def batch_actions
    items = params[:check_items]
    unless items.nil?
      items.each{|key,value|
        p = Personalcharge.find(value)
        case params[:do_action]
        when "approval":
          p.approval if p.state == "pending"
        when "disapproval":
          p.disapproval if p.state == "pending"
        when "destroy":
          p.destroy if p.state == "pending"

        else

        end
      }
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
    @now_period = Period.find(:first, :conditions => sql_condition )
    #render(:action=>index,:text =>" #{cookie_value}")
  end

end
