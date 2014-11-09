class IndustriesController < ApplicationController
  def index
    @q = Industry.search(params[:q])
    @industries  = @q.result.paginate :page => params[:page]
  end

  def show
    @industry = Industry.find(params[:id])
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(params[:industry])
    if @industry.save
      redirect_to industries_path, notice: 'Industry was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @industry = Industry.find(params[:id])
  end

  def update
    @industry = Industry.find(params[:id])
    if @industry.update_attributes(params[:industry])
      redirect_to @industry, notice: 'Industry was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to industries_path
  end
end
