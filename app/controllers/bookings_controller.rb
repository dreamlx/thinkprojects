class BookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.xml
  before_filter :find_project

  def index
    @bookings = Booking.find(:all,:conditions=>["project_id = ? ",params[:project_id]])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.xml
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.xml
  def new
    @booking = Booking.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.xml
  def create
    @booking = Booking.new(params[:booking])

    respond_to do |format|
      if (@project.bookings <<@booking)
        format.html { redirect_to(project_url(@project), :notice => 'Booking was successfully created.') }
        format.xml  { render :xml => @booking, :status => :created, :location => @booking }
        format.js
      else
        format.html { redirect_to(project_url(@project), :notice => '<font color=red>employee already exist, please destroy record first.</font>') }
        format.xml  { render :xml => @booking.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def bookall
    employees = Person.workings
    
    for employee in employees
      book= Booking.new
      book.person_id = employee.id
      book.hours = 0
      @project.bookings << book
    end
    respond_to do |format|
      format.html { redirect_to(project_url(@project), :notice => 'Booking was successfully created.') }
    end
  end
  # PUT /bookings/1
  # PUT /bookings/1.xml
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to(@booking, :notice => 'Booking was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.xml
  def destroy
    @booking = @project.bookings.find(params[:id])
    @project.bookings.delete(@booking)

    respond_to do |format|
      format.html { redirect_to(project_url(@project)) }
      format.xml  { head :ok }
    end
  end

  private
  def find_project
    @project_id = params[:project_id]
    redirect_to projects_url unless @project_id
    @project= Project.find(@project_id)
  end
end
