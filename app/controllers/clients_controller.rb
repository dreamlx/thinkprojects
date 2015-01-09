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
    # @client = Client.new(params[:client])
    @client = Client.new(client_params)
    if @client.save
      redirect_to(@client, :notice => 'Client was successfully created.')
    else
      render "new"
    end
  end

  def update
    @client = Client.find(params[:id])
    # if @client.update_attributes(params[:client])
    if @client.update_attributes(client_params)
      redirect_to(@client, :notice => 'Client was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    redirect_to(clients_url)
  end

  private
    def client_params
      params.require(:client).permit(:client_code, :chinese_name, :english_name, :user_id, 
                  :industry_id, :category_id, :status_id, :region_id, :contacts_attributes)
    end
end
