class ReceiveAmount < ActiveRecord::Base
  belongs_to   :billing
  attr_accessible :created_on, :updated_on, :invoice_no, :receive_date, :receive_amount, 
                  :id, :billing_id, :job_code
end
