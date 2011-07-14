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
    level = Authorization.current_user.role_symbols.to_s
    flag_lv = false

    flag_lv = true if level =='manager'
    flag_lv = true if level =='director'
    flag_lv = true if level =='providence_breaker'

    return flag_lv
  end


  def select_employee(model,id,current_user)
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
      { :include_blank => true }
    )
  end

  def select_partner(model,id)
    select(model, id,
      Person.find(:all,:conditions=>"position like '%director%' or position like 'partner' ",:order=>"english_name").collect {|p| [ p.english_name+"||"+p.employee_number, p.id ] },
      { :include_blank => true }
    )
  end

  def select_period(model,id)
    select(model, id, Period.find(:all,:order=>"number DESC").collect {|p| [ p.number, p.number ] }, { :include_blank => true })
  end

  def select_my_projects(model,id)
    select( model,id , Person.find(current_user.person_id).my_projects("","").collect {|p| [ p.job_code, p.id ] }, { :include_blank => true })
  end
end
