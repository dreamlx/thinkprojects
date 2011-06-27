class Booking < ActiveRecord::Base
  #validates_uniqueness_of :person_id
  belongs_to :project
  belongs_to :person

end
