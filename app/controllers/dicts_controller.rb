class DictsController < ApplicationController
  def index
     dict = Dict.new(params[:dict])
    sql = ' 1 '
    sql += " and title like '%#{dict.title}%'" if dict.title.present?
    sql += " and category like '%#{dict.category}%'" if dict.category.present?
    @dicts = Dict.search_by_sql(sql,params[:page])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dicts.to_xml }
    end
  end

  def show
    @dict = Dict.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dict.to_xml }
    end
  end

  def new
    @dict= Dict.new
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dict.to_xml }
    end
  end

  def edit
    @dict = Dict.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dict.to_xml }
    end
  end

  def create
    @dict = Dict.new(params[:dict])
    respond_to do |format|
      if @dict.save
        flash[:notice] = 'dict was successfully created.'
        
        format.html { redirect_to dict_url(@dict) }
        format.xml  { head :created, :location => dict_url(@dict) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dict.errors.to_xml }
      end
    end
  end

  def update
    @dict = Dict.find(params[:id])
    respond_to do |format|
      if @dict.update_attributes(params[:dict])
        
        flash[:notice] = 'Dict was successfully updated.'
        format.html { redirect_to dict_url(@dict) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dict.errors.to_xml }
      end
    end
  end

  def destroy
    @dict = Dict.find(params[:id])
    @dict.destroy

    #respond_to do |format|
    #  format.html { redirect_to projects_url }
    #  format.xml  { head :ok }
    #end
    render :update do |page|
      page.remove "item_#{params[:id]}"
      #page.replace_html 'flash_notice', "project was deleted"
    end
  end

end
