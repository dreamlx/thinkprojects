#coding: utf-8
class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  # before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  # before_filter :new_user, :only => :new
  # # filter_access_to :all
  # filter_access_to [:show, :edit, :update], :attribute_check => true

  def index
    @users= User.all
  end

  # render new.rhtml
  def new
    new_user
  end
 
  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "注册成功"
    else
      flash[:error]  = "注册失败"
      render :action => 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "更新用户成功。"
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "删除用户成功。"
    redirect_to users_url
  end

  protected
  def load_user
    @user = User.find params[:id]
  end

  def new_user
    @user = User.new
  end
end
