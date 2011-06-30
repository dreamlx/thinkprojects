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
end
