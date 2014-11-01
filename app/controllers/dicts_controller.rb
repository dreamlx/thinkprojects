class DictsController < ApplicationController
  def index
    dict = Dict.new(params[:dict])
    sql = ' 1 '
    sql += " and title like '%#{dict.title}%'" if dict.title.present?
    sql += " and category like '%#{dict.category}%'" if dict.category.present?
    @dicts = Dict.paginate(:page => params[:page]) #search_by_sql(sql,params[:page])
  end

  def show
    @dict = Dict.find(params[:id])
  end

  def new
    @dict= Dict.new
  end

  def edit
    @dict = Dict.find(params[:id])
  end

  def create
    @dict = Dict.new(params[:dict])
    if @dict.save
      flash[:notice] = 'dict was successfully created.'
      
      redirect_to @dict
    else
      render "new"
    end
  end

  def update
    @dict = Dict.find(params[:id])
    if @dict.update_attributes(params[:dict])
      flash[:notice] = 'Dict was successfully updated.'
      redirect_to @dict
    else
      ender "edit"
    end
  end

  def destroy
    Dict.find(params[:id]).destroy
    redirect_to dicts_path
  end
end
