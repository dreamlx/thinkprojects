class Expense < ActiveRecord::Base
  # human names
  ModelName = "Expense"
  ColumnNames ={
    :created_on => "created_on",
    :updated_on => "updated_on",
    :commission => "commission",
    :outsourcing => "outsourcing",
    :tickets => "tickets",
    :courrier => "courrier",
    :postage => "postage",
    :stationery => "stationery",
    :report_binding => "report binding",
    :cash_advance => "cash advance",
    :payment_on_be_half => "payment on be half",
    :memo => "memo"
  }
  belongs_to :project
  belongs_to :period
end
