# To change this template, choose Tools | Templates
# and open the template in the editor.
module ProjectsHelper
  def budgeted_expense_title
    # "硬体成本"
  end

  def check_message(project)
    profit = project.estimated_annual_fee - project.budgeted_service_fee - project.budgeted_expense
    subfee = project.estimated_annual_fee*25/100 - profit
    #return "Project profit=#{profit},cost=#{subfee}"
    return ""
  end

  def label_title(title)
    str =""
    case title
    when "budgeted_expense":
        str = " -硬体成本"
    when "estimated_annual_fee":
        str = " -预估总体成本"
    when "estimated_hours":
        str = " -预估总人时数"
    end
    #return str
    return ""
    
  end
  
  def allow_project_op(project)
    flag = false
    flag = true if current_user.person_id == project.partner_id or current_user.person_id == project.manager_id 
    flag = true if current_user.roles =="providence_breaker"
    return flag
  end

  def approval_op(project)
    flag = allow_project_op(project)
    flag = false if current_user.person_id == project.manager_id
    flag = true if current_user.person_id == project.partner_id

    return flag
  end
end