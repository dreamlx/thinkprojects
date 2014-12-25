class Personalcharge < ActiveRecord::Base
  acts_as_commentable

  # validates :hours, numericality: true
  # validates :ot_hours, numericality: true
  belongs_to :project
  belongs_to :period 
  belongs_to :user
  state_machine :initial => :pending do
    event :approval do
      transition all =>:approved
    end
    event :disapproval do
      transition all => :disapproved
    end
    event :reset do
      transition all => :pending
    end
  end
end
