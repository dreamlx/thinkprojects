class PeriodsController < ApplicationController
  def index
    # sql = "1  and number like '%#{params[:period][:number]}%'" unless params[:period].nil?
    # @periods = Period.search_by_sql(sql,params[:page]||1)
    @q = Period.search(params[:q])
    @periods = @q.result.paginate(page: params[:page])
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
      flash[:notice] = 'Period was successfully created.'
      redirect_to @period
    else
      render "new"
    end
  end

  def update
    @period = Period.find(params[:id])

    if @period.update_attributes(params[:period])
      flash[:notice] = 'Period was successfully updated.'
      redirect_to @period
    else
      render "edit"
    end
  end

  def destroy
    Period.find(params[:id]).destroy
    redirect_to periods_url
  end
end
