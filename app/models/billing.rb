class Billing < ActiveRecord::Base
  validates :project_id, presence: true
  belongs_to :project
  belongs_to :user
  belongs_to :person
  has_many  :receive_amounts
  attr_accessible :outstanding, :status, :project_id, :period_id, :user_id, :number, :billing_date, :service_billing, :expense_billing, :days_of_ageing, :business_tax, :write_off, :provision, :collection_days

  def self.selected_status
    [['all',''],['outstanding','outstanding'],['received','received']]
  end
end
