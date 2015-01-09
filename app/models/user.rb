#coding: utf-8
require 'digest/sha1'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1

  scope :workings, -> { where.not(status: 'resigned')}
  has_many  :clients
  has_many  :expenses
  has_many  :bookings
  has_many  :personalcharges
  has_many  :projects, through: :bookings

  def self.selected_roles
    [['staff','staff'],['senior','senior'],['manager','manager'],['partner','partner'],['hr_admin','hr_admin'],['超级管理员','providence_breaker']]
  end

  def self.selected_users
    order("english_name").map {|p| [ "#{p.english_name} || #{p.employee_number}", p.id ]}
  end
end