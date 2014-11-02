class Booking < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope =>"project_id"
  belongs_to :project
  belongs_to :user
  attr_accessible :user_id, :hours
end
