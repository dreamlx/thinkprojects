class DeductionsController < ApplicationController
  def index
    #list
    #render :action => 'list'
    id = params[:prj_id]
    item_found =Deduction.find(:first,:conditions=>['project_id=?',id])
    if item_found.nil?
      redirect_to :action => 'new',:id=> id
    else
      redirect_to :action => 'show',:id => item_found
    end    
  end


  def list
    @deductions  = Deduction.paginate :page => params[:page], :per_page => 20,:joins =>"inner join projects on deductions.project_id = projects.id ",
                                                :order_by => "projects.job_code"
  end

  def show
    @deduction = Deduction.find(params[:id])
  end

  def new
    init_set
    @deduction = Deduction.new
    @deduction.project_id = params[:id]
  end

  def create
    @deduction = Deduction.new(params[:deduction])
    if @deduction.save
      flash[:notice] = 'Deduction was successfully created.'
      redirect_to :action => 'show', :id => @deduction
    else
      render :action => 'new'
    end
  end

  def edit
    init_set
    @deduction = Deduction.find(params[:id])
  end

  def update
    @deduction = Deduction.find(params[:id])
    if @deduction.update_attributes(params[:deduction])
      flash[:notice] = 'Deduction was successfully updated.'
      redirect_to :action => 'show', :id => @deduction
      
    else
      render :action => 'edit'
    end
  end

  def destroy
    Deduction.find(params[:id]).destroy
    redirect_to :controller =>'deductions', :action => 'list'
  end

end
