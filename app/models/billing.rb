class Billing < ActiveRecord::Base
  validates_presence_of :project_id
  belongs_to :project
  belongs_to :period
  belongs_to :person
  has_many  :receive_amounts
end
