
class PersonalchargesController < ApplicationController
  filter_access_to :all

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)

  def index

    sql =" 1 "
    sql+=" and person_id=#{params[:person_id]}"     if params[:person_id].present?
    sql+=" and project_id=#{params[:prj_id]}"       if params[:prj_id].present?
    sql += " and state = '#{params[:state]}'"       if params[:state].present?
    sql += " and periods.starting_date >= '#{params[:period_from]}' "   if params[:period_from].present?
    sql += " and periods.ending_date   <= '#{params[:period_to]}' "     if params[:period_to].present?
    

    @personalcharges = Personalcharge.paginate_by_sql(sql,params[:page]||1)

    #OT
    @standard_hours = Personalcharge.standard_hours(sql)
    @ot_hours       = Personalcharge.ot_hours(sql)
    @ot_pay_hours   = Personalcharge.ot_pay_hours(sql)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @personalcharges.to_xml }
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
    @personalcharge = Personalcharge.find(params[:id])
    @personalcharge.state= "pending" if @personalcharge.state.nil?
    @personalcharge.approval

    respond_to do |format|
      format.html { redirect_to personalcharges_path }
    end
  end

  def disapproval
    @personalcharge = Personalcharge.find(params[:id])
    @personalcharge.state= "pending" if @personalcharge.state.nil?
    @personalcharge.disapproval

    respond_to do |format|
      format.html { redirect_to personalcharges_path }
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


    respond_to do |format|
      format.html { redirect_to personalcharges_url }
      format.xml  { head :ok }
    end

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
