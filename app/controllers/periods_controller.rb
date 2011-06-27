class PeriodsController < ApplicationController
  # GET /periods
  # GET /periods.xml
  def index
    #@periods = Period.find(:all)
    sql = "1"
    sql = sql + "  and number like '%#{params[:period][:number]}%'" unless params[:period].nil?


    @periods = Period.search_by_sql(sql,params[:page]||1)
    

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @periods.to_xml }
    end
  end

  # GET /periods/1
  # GET /periods/1.xml
  def show
    @period = Period.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @period.to_xml }
    end
  end

  # GET /periods/new
  def new
    @period = Period.new
  end

  # GET /periods/1;edit
  def edit
    @period = Period.find(params[:id])
  end

  # POST /periods
  # POST /periods.xml
  def create
    @period = Period.new(params[:period])

    respond_to do |format|
      if @period.save
        flash[:notice] = 'Period was successfully created.'
        format.html { redirect_to period_url(@period) }
        format.xml  { head :created, :location => period_url(@period) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @period.errors.to_xml }
      end
    end
  end

  # PUT /periods/1
  # PUT /periods/1.xml
  def update
    @period = Period.find(params[:id])

    respond_to do |format|
      if @period.update_attributes(params[:period])
        flash[:notice] = 'Period was successfully updated.'
        format.html { redirect_to period_url(@period) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @period.errors.to_xml }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.xml
  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    respond_to do |format|
      format.html { redirect_to periods_url }
      format.xml  { head :ok }
    end
  end
end
