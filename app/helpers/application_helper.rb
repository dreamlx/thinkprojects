# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  def allow_lv
    level = current_user.roles

    (level =='providence_breaker')? flag_lv = true : flag_lv = false

    return flag_lv
  end


  def select_employee(model,id)
    case current_user.roles
    when "providence_breaker":
      select_people(model,id)
    else
      select_person(model,id)
    end

  end

  def select_person(model,id)
    select(model, id,
    Person.find(:all,
    :conditions=>["id=?", current_user.person_id]).collect {|p| [ p.english_name+"||"+p.employee_number, p.id ] },
    { :include_blank => false }
    )
  end

  def select_people(model,id)
    select(model, id,
    Person.find(:all,:order=>"english_name").collect {|p| [ p.english_name+"||"+p.employee_number, p.id ] },
    { :include_blank => "All" }
    )
  end

  def select_partner(model,id)
    select(model, id,
    Person.find(:all,:conditions=>"position like '%director%' or position like 'partner' ",:order=>"english_name").collect {|p| [ p.english_name+"||"+p.employee_number, p.id ] },
    { :include_blank => "All" }
    )
  end

  def select_manager(model,id)
    select(model, id,
    Person.find(:all,:conditions=>"position like '%manager%'  ",:order=>"english_name").collect {|p| [ p.english_name+"||"+p.employee_number, p.id ] },
    { :include_blank => "All" }
    )
  end

  def select_period(model,id)
    select(model, id, Period.find(:all,:order=>"number DESC").collect {|p| [ p.number, p.number ] }, { :include_blank => "All" })
  end

  def select_my_projects(model,id)
    select( model,id , 
    Project.my_projects(current_user,"1","job_code").collect {|p| [ p.job_code, p.id ] }, { :include_blank => "All" })
  end

  def select_booked_project(model,id)
    case current_user.roles
    when "providence_breaker":
      select( model,id , Project.alive.collect {|p| [ p.job_code + "|" + p.client.english_name, p.id ] }, { :include_blank => false })
    else
      select(model,id,
      Project.my_bookings(current_user.person_id).collect {|p| [ p.job_code + "|" + p.client.english_name, p.id ] }, { :include_blank => false })
    end
  end

  def check_menu(title,current_user)
    flag = false
    flag = true if (title == 'System Peferences' or title == 'Report' ) and (current_user.roles != 'providence_breaker' or current_user.roles != 'partner')
   
    return flag
  end

end
