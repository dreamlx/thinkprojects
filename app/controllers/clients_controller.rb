class ClientsController < ApplicationController
  before_filter :set_params, only: [:new, :edit, :create]
  def index
    @statuses = Dict.where("category ='client_status'")
    @client = Client.new(params[:client])
    sql = "1"
    sql += " and client_code like '%"+@client.client_code+"%' " if @client.client_code
    sql += " and chinese_name like '%"+@client.chinese_name+"%' " if @client.chinese_name
    if !@client.client_code.empty?
      @clients = Client.where(sql).order(english_name).paginate :page => params[:page]
    else
      @clients  = Client.order('english_name').paginate :page => params[:page]
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

  private
    def set_params
      @industries     = Industry.all.map {|i| ["#{i.code}||#{i.title}", i.id]}
      @categories     = Dict.where("category ='client_category'").order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
      @statuses       = Dict.where("category ='client_status'").order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
      @regions        = Dict.where("category ='region'").order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
      @gender         = Dict.where("category ='gender'").order("code")
      @account_owners = User.order('english_name').map {|a| ["#{a.english_name}--#{a.employee_number}", a.id]}
    end
end
