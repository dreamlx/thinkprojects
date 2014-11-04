class ClientsController < ApplicationController
  def index
    @client = Client.new(params[:client])
    sql = "1"
    sql += " and client_code like '%"+@client.client_code+"%' " if @client.client_code
    sql += " and chinese_name like '%"+@client.chinese_name+"%' " if @client.chinese_name
    if !@client.client_code.empty?
      @clients = Client.where(sql).order(english_name).paginate(page: params[:page])
    else
      @clients  = Client.order('english_name').paginate(page: params[:page])
    end
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
