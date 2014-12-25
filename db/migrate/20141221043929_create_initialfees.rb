class CreateInitialfees < ActiveRecord::Migration
  def change
    create_table :initialfees do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.decimal :service_fee
      t.decimal :commission
      t.decimal :outsourcing
      t.decimal :reimbursement
      t.decimal :meal_allowance
      t.decimal :travel_allowance
      t.decimal :business_tax
      t.decimal :tickets
      t.decimal :courrier
      t.decimal :postage
      t.decimal :stationery
      t.decimal :report_binding
      t.decimal :payment_on_be_half
      t.integer :project_id
      t.decimal :cash_advance
    end
  end
end
