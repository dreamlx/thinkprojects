class Deduction < ActiveRecord::Base
  attr_accessible :created_on, :expense_PFA, :expense_UFA, :expense_billing, :project_id, :service_PFA, :service_UFA, :service_billing, :updated_on, :id
end
