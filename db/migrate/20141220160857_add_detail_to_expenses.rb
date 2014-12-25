class AddDetailToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :created_on, :timestamp
    add_column :expenses, :updated_on, :timestamp
    add_column :expenses, :commission, :decimal
    add_column :expenses, :outsourcing, :decimal
    add_column :expenses, :tickets, :decimal
    add_column :expenses, :courrier, :decimal
    add_column :expenses, :postage, :decimal
    add_column :expenses, :stationery, :decimal
    add_column :expenses, :report_binding, :decimal
    add_column :expenses, :cash_advance, :decimal
    add_column :expenses, :payment_on_be_half, :decimal
    add_column :expenses, :memo, :string
  end
end
