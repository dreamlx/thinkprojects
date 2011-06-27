class IndustriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end


  def list
    @industries  = Industry.paginate :page => params[:page], :per_page => 10
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
      flash[:notice] = 'Industry was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @industry = Industry.find(params[:id])
  end

  def update
    @industry = Industry.find(params[:id])
    if @industry.update_attributes(params[:industry])
      flash[:notice] = 'Industry was successfully updated.'
      redirect_to :action => 'show', :id => @industry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Industry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
