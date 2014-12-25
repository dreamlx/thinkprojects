class Billing < ActiveRecord::Base
  validates :project_id, presence: true
  belongs_to :project
  belongs_to :user
  belongs_to :person
  has_many  :receive_amounts

  def self.selected_status
    [['outstanding','0'],['received','1']]
  end
end