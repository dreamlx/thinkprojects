class ContactsController < ApplicationController
  def index
    list
    render :action => 'list'
  end


  def list
    @contacts  = Contact.paginate  :per_page => 10
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:notice] = 'Contact was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = 'Contact was successfully updated.'
      redirect_to :action => 'show', :id => @contact
    else
      render :action => 'edit'
    end
  end

  def destroy
    Contact.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
