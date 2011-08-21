class AdminsController < ApplicationController
  def index

  end
  
  def auto_complete_hours
    period = Period.find(params[:period_id])
    @people = Person.workings
    @sum_records =[]
    period_hours =  params[:period_hours]
    @message_items =""
    @messages="<table><tr><th>epmloyee</th><th>personalcharge hours</th> <th>work hours - charge hours</th></tr>"
    @people.each do|p|
      sum_personalcharge = Personalcharge.sum("hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id}")
      sum_ot_hours = Personalcharge.sum("ot_hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id}")
      sum_self_study = Personalcharge.sum("hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id} and project_id = #{params[:prj_id]}")
      self_study = Personalcharge.new
      self_study.project_id = params[:prj_id]
 
      self_study.hours= period_hours.to_f - (sum_personalcharge - sum_ot_hours) - sum_self_study
      self_study.period_id = period.id
      self_study.person_id = p.id
      self_study.desc=" auto complete by admin"
      self_study.ot_hours =0
      self_study.charge_date = Time.now
      self_study.service_fee=0
      @messages += "<tr><td>#{p.english_name}</td><td>#{sum_personalcharge}</td><td>#{self_study.hours}</td></tr>"
      if  self_study.hours > 0
        self_study.save
        self_study.approval
        @sum_records << self_study
        @message_items +="#{p.english_name} inserted."
      end
    end
    @messages +="</table>"
    flash[:notice] = "#{period.number}--selfstduy was checked and insert #{@sum_records.count} reocords"
    

  end
  def check_ot
    period = Period.find(params[:period_id])
    period_hours =  params[:period_hours]

    @people = Person.workings
   
    @messages="<table><tr><td>epmloyee</td><td>personalcharge hours</td> <td>work hours </td><td>OT</td></tr>"
    @people.each do|p|
      sum_personalcharge = Personalcharge.sum("hours",:conditions=>"period_id =#{period.id} and person_id = #{p.id}")
      if  sum_personalcharge > period_hours.to_f
        @messages += "<tr><td>#{p.english_name}</td><td>#{sum_personalcharge}</td><td>#{period_hours.to_f }</td><td>#{sum_personalcharge - period_hours.to_f }</td></tr>"
      end
    end
    @messages +="</table>"
  end
  

end
