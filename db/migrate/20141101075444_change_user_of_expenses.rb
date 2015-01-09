class ChangeUserOfExpenses < ActiveRecord::Migration
  def up
    add_column :expenses, :user_id, :integer
    Expense.all.each do |expense|
      expense.user_id = User.find_by_person_id(expense.person_id).id
      expense.save
    end
    remove_column :expenses, :person_id
  end

  def down
    add_column :expenses, :person_id, :integer
    Expense.all.each do |expense|
      expense.person_id = User.find(expense.user_id).person_id
      expense.save
    end
    remove_column :expenses, :user_id
  end
end
