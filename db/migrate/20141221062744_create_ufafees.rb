class CreateUfafees < ActiveRecord::Migration
  def change
    create_table :ufafees do |t|
      t.timestamp :created_on
      t.timestamp :updated_on
      t.string :number
      t.decimal :amount
      t.integer :project_id
      t.string :period_id
      t.decimal :service_UFA
      t.decimal :expense_UFA

      t.timestamps
    end
  end
end
