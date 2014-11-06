#coding: utf-8
require 'digest/sha1'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :login, :name, :roles, :person_id,
                  :english_name, :employee_number, :charge_rate, :employment_date, 
                  :address, :postalcode, :mobile, :tel, :gender, :department_id, :status_id
  validates :login, presence: true, length: {in: 3..40}
  validates :name,  length:   {maximum: 100}
  validates :email, presence: true, uniqueness: true, length: {in: 6..100}

  has_one   :person
  has_many  :clients
  has_many  :expenses

  scope :workings, :conditions =>"dicts.title <> 'Resigned' and dicts.category = 'person_status' ", :include=>:status,:order =>"english_name"

  def self.selected_roles
    [['staff','staff'],['senior','senior'],['manager','manager'],['partner','partner'],['hr_admin','hr_admin'],['超级管理员','providence_breaker']]
  end

  def self.selected_users
    User.order("english_name").map {|p| [ "#{p.english_name} || #{p.employee_number}", p.id ]}
  end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def role_symbols
    @role_symbols ||= roles
  end

  def my_bookings
    mybookings = Booking.joins(" left join projects on projects.id = bookings.project_id").where(user_id: self.id).select("distinct project_id,job_code, state, user_id")
    myprojects=[]
    for mybooking in mybookings
      myprojects << mybooking.project if mybooking.state == "approved"
    end

    prjs =myprojects.sort_by{|p| p.job_code}
    return prjs
  end

  def self.my_teams(current_user)
    projects = Project.all
    my_bookings = []
    projects.each{|project| my_bookings<< project.bookings if project.is_booking?(current_user.id) }
    my_bookings =   Hash[*my_bookings.map {|obj| [obj.user_id, obj]}.flatten].values

    ids=""
    my_bookings.each{|booking| ids += (booking.user_id.to_s+",")} 
    ids += " 0 "

    teams = self.where("id in (#{ids})").order("english_name")

    case 
      when current_user.roles == "providence_breaker"
        teams = self.order("english_name")
      when current_user.roles == "partner"
        teams = self.order("english_name")
      when current_user.roles == "manager"
        teams = self.where("id in (#{ids})").order("english_name")
      when current_user.roles == "senior"
        teams = self.where("id = #{current_user.person_id}")       
      when current_user.roles == "staff"
        teams = self.where("id = #{current_user.person_id}")
    else
        teams = self.order("english_name")
    end
    
    return teams
  end

  belongs_to :GMU,
    :class_name => "Dict",
    :foreign_key => "GMU_id",
    :conditions => "category ='GMU'"
  
  belongs_to :status,
    :class_name => "Dict",
    :foreign_key => "status_id",
    :conditions => "category = 'person_status'"

  belongs_to :department,
    :class_name => "Dict",
    :foreign_key => "department_id",
    :conditions => "category = 'department'"
end
