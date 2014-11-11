class ClientsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Client.search(params[:q])
    @clients  = @q.result.order('english_name').paginate(page: params[:page])
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end
  
  def create
    @client = Client.new(params[:client])
    if @client.save
      redirect_to(@client, :notice => 'Client was successfully created.')
    else
      render "new"
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      redirect_to(@client, :notice => 'Client was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    redirect_to(clients_url)
  end
end
