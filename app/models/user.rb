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
  validates :name, length: {maximum: 100}
  validates :email, presence: true, uniqueness: true, length: {in: 6..100}

  has_one   :person
  has_many  :clients
  has_many  :expenses

  def self.selected_roles
    [['staff','staff'],['senior','senior'],['manager','manager'],['partner','partner'],['hr_admin','hr_admin'],['超级管理员','providence_breaker']]
  end

  def self.selected_persons
    Person.order("english_name").map {|p| [ p.english_name+"||"+p.employee_number, p.id ]}
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
