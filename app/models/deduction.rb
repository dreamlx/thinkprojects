class Deduction < ActiveRecord::Base
  belongs_to :project
  belongs_to :period

end
