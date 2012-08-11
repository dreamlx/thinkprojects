module PersonalchargesHelper
  def warn_ot_hours(current_item,items)
    if OverTime.allow_ot?(current_item,items) or current_item.ot_hours == 0
      return ""
    else
      return "#E6E6E6"
    end
  end
  
end
