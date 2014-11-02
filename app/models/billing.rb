class Billing < ActiveRecord::Base
  validates_presence_of :project_id
  belongs_to :project
  belongs_to :user
  belongs_to :person
  has_many  :receive_amounts
  attr_accessible :outstanding, :status
end
