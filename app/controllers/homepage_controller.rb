class HomepageController < ApplicationController
  def index
    if logged_in?
    @projects = Project.my_projects(current_user)||[]
     flash[:notice] = '请等待管理员分配用户，谢谢' if current_user.person_id.blank? or current_user.person_id.nil?
    end
  end
end
