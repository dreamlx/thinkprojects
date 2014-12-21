class PrjExpenseLog < ActiveRecord::Base
  attr_accessible :id, :other, :prj_id, :expense_id, :period_id
end
