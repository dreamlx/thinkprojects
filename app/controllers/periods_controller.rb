class PeriodsController < ApplicationController
  def index
    @q = Period.search(params[:q])
    @periods = @q.result.order(:number).paginate(page: params[:page])
  end

  def show
    @period = Period.find(params[:id])
  end

  def new
    @period = Period.new
  end

  def edit
    @period = Period.find(params[:id])
  end

  def create
    @period = Period.new(params[:period])

    if @period.save
      redirect_to @period, notice: 'Period was successfully created.'
    else
      render "new"
    end
  end

  def update
    @period = Period.find(params[:id])

    if @period.update_attributes(params[:period])
      redirect_to @period, notice: 'Period was successfully updated.'
    else
      render "edit"
    end
  end

  def destroy
    Period.find(params[:id]).destroy
    redirect_to periods_url
  end
end
