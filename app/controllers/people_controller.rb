class PeopleController < ApplicationController
# # filter_access_to :all
  def index
    person = Person.new(params[:person])
    sql = ' 1 '
    sql += " and employee_number like '%#{person.employee_number}%'" if person.employee_number.present?
    sql += " and english_name like '%#{person.english_name}%'" if person.english_name.present?
    sql += " and chinese_name like '%#{person.chinese_name}%'" if person.chinese_name.present?
    @people = Person.paginate(:page => params[:page]) #search_by_sql(sql,params[:page])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @people.to_xml }
    end
  end

  def show
    @person=Person.find(params[:id])
  end

  def edit
    @person=Person.find(params[:id])
  end

  def new
    @person=Person.new
  end

  def create
    @person = Person.new(params[:person])
    respond_to do |format|
      if @person.save
        flash[:notice] = 'Employee was successfully created.'
        
        format.html { redirect_to person_url(@person) }
        format.xml  { head :created, :location => person_url(@person) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors.to_xml }
      end
    end
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update_attributes(params[:person])

        flash[:notice] = 'Employee was successfully updated.'
        format.html { redirect_to person_url(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors.to_xml }
      end
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to people_url }
      format.xml  { head :ok }
    end
  end
  
end
