class DictsController < ApplicationController
  load_and_authorize_resource
  def index
    @q = Dict.search(params[:q])
    @dicts = @q.result.paginate(:page => params[:page])
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
    # @dict = Dict.new(params[:dict])
    @dict = Dict.new(dict_params)
    if @dict.save      
      redirect_to @dict, notice: 'dict was successfully created.'
    else
      render "new"
    end
  end

  def update
    @dict = Dict.find(params[:id])
    # if @dict.update_attributes(params[:dict])
    if @dict.update_attributes(dict_params)
      redirect_to @dict, notice: 'Dict was successfully updated.'
    else
      ender "edit"
    end
  end

  def destroy
    Dict.find(params[:id]).destroy
    redirect_to dicts_path
  end

  private
    def dict_params
      params.require(:dict).permit(:category, :code, :title)
    end
end
