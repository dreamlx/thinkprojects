class BookingsController < ApplicationController
  load_and_authorize_resource
  before_filter :find_project
  def create
    # @booking = @project.bookings.build(params[:booking])
    @booking = @project.bookings.build(booking_params)
    if @booking.save
      redirect_to(@project, :notice => 'Booking was successfully created.')
    else
      redirect_to(@project, :notice => 'employee already exist, please destroy record first.')
    end
  end

  def destroy
    @booking = @project.bookings.find(params[:id])
    if @booking.user_id != @project.manager_id
      @booking.destroy
      redirect_to @project, notice: "Success"
    else
      redirect_to @project, notice: "The user is manager"
    end
  end

  def bookall
    User.workings.each do |employee|
      @project.bookings.create(user_id: employee.id, hours: 0)
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

    def booking_params
      params.require(:booking).permit(:user_id, :hours, :project_id)
    end
end