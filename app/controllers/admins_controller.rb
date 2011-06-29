class AdminsController < ApplicationController
  def index

  end
  
  def auto_complete_hours
    period = Period.find(params[:period_id])
    unless params[:period_id].blank?
      person_status = Dict.find_by_title_and_category("Resigned","person_status")
      @people = Person.find(:all,
        :conditions => "status_id != '#{person_status.id}' ",
        :order => 'english_name')
      @sum_records =[]
      @messages="<table><tr><td>epmloyee</td><td>personalcharge hours</td> <td>work hours - charge hours</td></tr>"
      @people.each do|p|
        sum_personalcharge = Personalcharge.sum("hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id}")

     
        self_study = Personalcharge.new
        self_study.project_id = params[:prj_id]
        self_study.hours= period.work_hours - sum_personalcharge
        self_study.period_id = period.id
        self_study.person_id = p.id
        self_study.desc=" auto complete by admin"

        @messages += "<tr><td>#{p.english_name}</td><td>#{sum_personalcharge}</td><td>#{self_study.hours}</td></tr>"

        if  sum_personalcharge < period.work_hours
          self_study.save
          @sum_records << self_study
        end
      end
      @messages +="</table>"
      flash[:notice] = "#{period.number}--selfstduy was checked and insert #{@sum_records.count} reocords"
    end
  end

  def check_ot
    period = Period.find(params[:period_id])
    person_status = Dict.find_by_title_and_category("Resigned","person_status")
    @people = Person.find(:all,
      :conditions => "status_id != '#{person_status.id}' ",
      :order => 'english_name')
   
    @messages="<table><tr><td>epmloyee</td><td>personalcharge hours</td> <td>work hours </td><td>OT</td></tr>"
    @people.each do|p|
      sum_personalcharge = Personalcharge.sum("hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id}")
      if  sum_personalcharge > period.work_hours
        @messages += "<tr><td>#{p.english_name}</td><td>#{sum_personalcharge}</td><td>#{period.work_hours}</td><td>#{sum_personalcharge - period.work_hours}</td></tr>"
      end
    end
    @messages +="</table>"
  end
  

end
