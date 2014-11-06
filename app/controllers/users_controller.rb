#coding: utf-8
class UsersController < ApplicationController
  # # filter_access_to :all
  # filter_access_to [:show, :edit, :update], :attribute_check => true

  def index
    @q = User.search(params[:q])
    @users= @q.result.paginate(:page => params[:page]) #search_by_sql(sql,params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "更新用户成功。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "删除用户成功。"
    redirect_to users_path
  end
end
