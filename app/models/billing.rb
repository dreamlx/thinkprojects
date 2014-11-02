class Billing < ActiveRecord::Base
  validates :project_id, presence: true
  belongs_to :project
  belongs_to :user
  belongs_to :person
  has_many  :receive_amounts
  attr_accessible :outstanding, :status
end
