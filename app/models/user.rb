require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :encryptable, :encryptor => :restful_authentication_sha1

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :name, :roles, :person_id
  validates :login, presence: true, uniqueness: true, length: {in: 3..40}
  validates :name, length: {maximum: 100}
  validates :email, presence: true, uniqueness: true, length: {in: 6..100}

  has_one :person

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
end
