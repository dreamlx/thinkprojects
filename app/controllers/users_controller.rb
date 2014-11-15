#coding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    @q = User.search(params[:q])
    @users= @q.result.paginate(:page => params[:page])
    authorize! :read, @users
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # if @user.update_attributes(params[:user])
    if @user.update_attributes(user_params)
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :login, :name, :roles,
                                :english_name, :employee_number, :charge_rate, :employment_date, 
                                :address, :postalcode, :mobile, :tel, :gender, :department_id, :status_id)
  end
end
