#coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all # include all helpers, all the time
  include ApplicationHelper

  protected
    def permission_denied
      respond_to do |format|
        flash[:error] = '对不起，您没有足够的权限访问此页！'
        format.html { redirect_to :controller=>'homepage' }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end

    private
    def redirect_to_index(msg = nil)
      flash[:notice] = msg if msg
      redirect_to(:action => 'index')
    end

    def get_cookie
      cookie_value = cookies[:the_time]
      #cookie_value ||= 0
      return cookie_value
      #render(:action=>index,:text =>" #{cookie_value}")
    end

    def get_now_period
      cookie_period_id = cookies[:the_time]
      if cookie_period_id != ""
        sql_condition  = " id = '#{cookie_period_id}'"
      else
        sql_condition = "id = 0"
      end
      now_period = Period.where(:conditions => sql_condition ).first || Period.today_period

      return now_period
    end

    def billing_number_set
      @billing_number = Dict.where(:conditions =>" category ='billing_number' ").first
      @number = @billing_number.code.to_i + 1

      if @number <10
        @str_number = "000" + @number.to_s
      elsif @number <100
        @str_number = "00" + @number.to_s
      elsif @number <1000
        @str_number = "0" + @number.to_s
      else
        @str_number = @number.to_s
      end
    end

    def get_level
      #guest,employee,manager,partner,providence_breaker
      level = Authorization.current_user.role_symbols.to_s
      return level

    end
  
  protected
    def rescue_action_in_public(exception)
      case exception
      when ActiveRecord::RecordNotFound
        render_404
      else
        render_500
      end
    end
    # Scrub sensitive parameters from your log
    # filter_parameter_logging :password

    def set_current_user
      Authorization.current_user = current_user
    end

    def set_language

      request_language = request.env['HTTP_ACCEPT_LANGUAGE']

      request_language = request_language.nil? ? nil : request_language[/[^,;]+/]

      I18n.locale = request_language if request_language && File.exist?("#{Rails.root}/config/locales/#{request_language}.yml")

    end
    
    def convert_gb(str)  
      Iconv.iconv("GBK","UTF-8", str.to_s)  
    end
end
