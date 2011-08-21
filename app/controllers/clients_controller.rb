class ClientsController < ApplicationController
  # GET /clients
  # GET /clients.xml

    filter_access_to :all
  def index
    @statuses = Dict.find(:all,
      :conditions =>"category ='client_status'")

     @client = Client.new(params[:client])
    sql = "1"
     sql += " and client_code like '%"+@client.client_code+"%' " if @client.client_code
     sql += " and chinese_name like '%"+@client.chinese_name+"%' " if @client.chinese_name
    if @client.client_code
      #@clients = Client.find(:all,
      #                      :conditions => ['client_code like ?', @client.client_code])
      @clients = Client.find(:all,:conditions=>sql).paginate :page => params[:page], :per_page => 20, :order => 'client_code'
    else
      @clients  = Client.paginate :page => params[:page], :per_page => 20, :order => 'english_name,client_code'
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new

    @industries     = Industry.find(:all)
    @categories     = Dict.find(:all,
      :conditions =>"category ='client_category'",
      :order =>"code")
    @statuses       = Dict.find(:all,
      :conditions =>"category ='client_status'",
      :order =>"code")
    @regions        = Dict.find(:all,
      :conditions =>"category ='region'",
      :order =>"code")
    @gender         = Dict.find(:all,
      :conditions =>"category ='gender'",
      :order =>"code")
    @account_owners = Person.find(:all,
      :order => 'english_name')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
    @industries = Industry.find(:all)
    @categories = Dict.find(:all,
      :conditions =>"category ='client_category'", :order =>"code")
    @statuses   = Dict.find(:all,
      :conditions =>"category ='client_status'", :order =>"code")
    @regions    = Dict.find(:all,
      :conditions =>"category ='region'", :order =>"code")
    @gender     = Dict.find(:all,
      :conditions =>"category ='gender'", :order =>"code")
    @account_owners = Person.find(:all,
      :order => 'english_name')
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    @industries     = Industry.find(:all)
    @categories     = Dict.find(:all,
      :conditions =>"category ='client_category'",
      :order =>"code")
    @statuses       = Dict.find(:all,
      :conditions =>"category ='client_status'",
      :order =>"code")
    @regions        = Dict.find(:all,
      :conditions =>"category ='region'",
      :order =>"code")
    @gender         = Dict.find(:all,
      :conditions =>"category ='gender'",
      :order =>"code")
    @account_owners = Person.find(:all,
      :order => 'english_name')
    respond_to do |format|
      if @client.save
        format.html { redirect_to(@client, :notice => 'Client was successfully created.') }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to(@client, :notice => 'Client was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
end
