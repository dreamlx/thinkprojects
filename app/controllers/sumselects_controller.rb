class SumselectsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sumselects  = Sumselect.paginate :page => params[:page],, :per_page => 10
  end

  def show
    @sumselect = Sumselect.find(params[:id])
  end

  def new
    @sumselect = Sumselect.new
  end

  def create
    @sumselect = Sumselect.new(params[:sumselect])
    if @sumselect.save
      flash[:notice] = 'Sumselect was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sumselect = Sumselect.find(params[:id])
  end

  def update
    @sumselect = Sumselect.find(params[:id])
    if @sumselect.update_attributes(params[:sumselect])
      flash[:notice] = 'Sumselect was successfully updated.'
      redirect_to :action => 'show', :id => @sumselect
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sumselect.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
