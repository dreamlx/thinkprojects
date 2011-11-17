module PersonalchargesHelper
  def warn_ot_hours(current_item,items)
    if OverTime.allow_ot?(current_item,items)
      return ""
    else
      return "#cdc"
    end
  end
  
end
