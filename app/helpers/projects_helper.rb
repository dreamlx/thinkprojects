#coding: utf-8
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
    if title == "budgeted_expense"
      str = " -硬体成本"
    elsif title == "estimated_annual_fee"
      str = " -预估总体成本"
    elsif title == "estimated_hours"
      str = " -预估总人时数"
    end
    return ""
    #return str
  end
end