#coding: utf-8
require 'digest/sha1'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1

  # attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :name, :roles,
                  # :english_name, :employee_number, :charge_rate, :employment_date, 
                  # :address, :postalcode, :mobile, :tel, :gender, :department_id, :status_id
  validates :login, presence: true, length: {in: 3..40}
  validates :name,  length:   {maximum: 100}
  validates :email, presence: true, uniqueness: true, length: {in: 6..100}
  has_many  :clients
  has_many  :expenses
  has_many  :bookings
  has_many  :personalcharges
  has_many  :projects, through: :bookings
  # belongs_to :GMU,        class_name: "Dict", foreign_key: "GMU_id",        :conditions => "category ='GMU'" 
  belongs_to :GMU,        -> { where category: 'GMU' },               class_name: "Dict", foreign_key: "GMU_id"
  # belongs_to :status,     class_name: "Dict", foreign_key: "status_id",     :conditions => "category = 'person_status'"
  belongs_to :status,     ->{ where category:'person_status' } ,      class_name: "Dict", foreign_key: "status_id"   
  # belongs_to :department, class_name: "Dict", foreign_key: "department_id", :conditions => "category = 'department'"
  belongs_to :department, ->{ where category:'person_status' } ,      class_name: "Dict", foreign_key: "department_id"
  def self.workings
    includes(:status).where("dicts.title <> 'Resigned' and dicts.category = 'person_status' ").order("english_name")
  end

  def self.selected_roles
    [['staff','staff'],['senior','senior'],['manager','manager'],['partner','partner'],['hr_admin','hr_admin'],['超级管理员','providence_breaker']]
  end

  def self.selected_users
    order("english_name").map {|p| [ "#{p.english_name} || #{p.employee_number}", p.id ]}
  end
end