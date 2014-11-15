class Booking < ActiveRecord::Base
  validates   :user_id, uniqueness: {scope: :project_id}
  belongs_to  :project
  belongs_to  :user
  # attr_accessible :user_id, :hours, :project_id
end
