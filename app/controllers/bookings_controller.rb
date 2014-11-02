class BookingsController < ApplicationController
  before_filter :find_project

  def index
    @bookings = Booking.where(project_id: params[:project_id])
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def create
    @booking = Booking.new(params[:booking])

    if (@project.bookings <<@booking)
      redirect_to(@project, :notice => 'Booking was successfully created.')
    else
      redirect_to(@project, :notice => '<font color=red>employee already exist, please destroy record first.</font>')
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

  def destroy
    @booking = @project.bookings.find(params[:id])
    @project.bookings.delete(@booking) unless @booking.id == @project.manager_id
    redirect_to bookings_path
  end

  private
    def find_project
      @project_id = params[:project_id]
      redirect_to projects_url unless @project_id
      @project= Project.find(@project_id)
    end
end
