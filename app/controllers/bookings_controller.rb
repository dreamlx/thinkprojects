class BookingsController < ApplicationController
  before_filter :find_project
  def create
    @booking = Booking.new(params[:booking])
    if (@project.bookings << @booking)
      redirect_to(@project, :notice => 'Booking was successfully created.')
    else
      redirect_to(@project, :notice => 'employee already exist, please destroy record first.')
    end
  end

  def destroy
    @booking = @project.bookings.find(params[:id])
    @booking.destroy unless @booking.id == @project.manager_id
    redirect_to @project
  end

  def bookall
    employees = User.workings
    employees.each do |employee|
      book= Booking.new
      book.user_id = employee.id
      book.hours = 0
      @project.bookings << book
    end
    redirect_to(@project, :notice => 'Booking was successfully created.')
  end

  private
    def find_project
      if params[:project_id]
        @project= Project.find(params[:project_id])
      else
        redirect_to projects_url
      end
    end
end
