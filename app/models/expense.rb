class Expense < ActiveRecord::Base
  acts_as_commentable
  validates :charge_date, :user_id, presence: true
  validates :fee, numericality: true

  belongs_to :project
  belongs_to :period
  belongs_to :user

  attr_accessible :charge_date, :approved_by, :billable, :expense_category, :fee, :desc, :person_id, :project_id, :user_id
  
  state_machine :initial => :pending do
    event :approval do
      transition all =>:approved
    end
    event :disapproval do
      transition all => :disapproved
    end
    event :close do
      transition all => :closed
    end
    event :transform do
      transition :approval => :transformed
    end
    event :reset do
      transition all => :pending
    end
  end
end
