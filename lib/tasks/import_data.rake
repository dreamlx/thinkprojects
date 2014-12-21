require 'csv'

namespace :data do
  desc "import billings"
  task :billings => :environment do
    Billing.delete_all
    CSV.foreach('billings.csv', :headers => true) do |row|
      Billing.create!(row.to_hash)
    end
  end

  desc "import clients"
  task :clients => :environment do
    Client.delete_all
    CSV.foreach('clients.csv', :headers => true) do |row|
      Client.create!(row.to_hash)
    end
  end

  desc "import deductions"
  task :deductions => :environment do
    Deduction.delete_all
    CSV.foreach('deductions.csv', :headers => true) do |row|
      Deduction.create!(row.to_hash)
    end
  end
  desc "import dicts"
  task :dicts => :environment do
    Dict.delete_all
    CSV.foreach('dicts.csv', :headers => true) do |row|
      Dict.create!(row.to_hash)
    end
  end

  desc "import expenses"
  task :expenses => :environment do
    Expense.delete_all
    CSV.foreach('expenses.csv', :headers => true) do |row|
      Expense.create!(row.to_hash)
    end
  end

  desc "import industries"
  task :industries => :environment do
    Industry.delete_all
    CSV.foreach('industries.csv', :headers => true) do |row|
      Industry.create!(row.to_hash)
    end
  end

  desc "import initialfees"
  task :initialfees => :environment do
    Initialfee.delete_all
    CSV.foreach('initialfees.csv', :headers => true) do |row|
      Initialfee.create!(row.to_hash)
    end
  end

  desc "import people"
  task :people => :environment do
    Person.delete_all
    CSV.foreach('people.csv', :headers => true) do |row|
      Person.create!(row.to_hash)
    end
  end

  desc "import periods"
  task :periods => :environment do
    Period.delete_all
    CSV.foreach('periods.csv', :headers => true) do |row|
      Period.create!(row.to_hash)
    end
  end

  desc "import personalcharges"
  task :personalcharges => :environment do
    Personalcharge.delete_all
    CSV.foreach('personalcharges.csv', :headers => true) do |row|
      Personalcharge.create!(row.to_hash)
    end
  end

  desc "import prj_expense_logs"
  task :prj_expense_logs => :environment do
    PrjExpenseLog.delete_all
    CSV.foreach('prj_expense_logs.csv', :headers => true) do |row|
      PrjExpenseLog.create!(row.to_hash)
    end
  end

  desc "import projects"
  task :projects => :environment do
    Project.delete_all
    CSV.foreach('projects.csv', :headers => true) do |row|
      Project.create!(row.to_hash)
    end
  end

  desc "import receive_amounts"
  task :receive_amounts => :environment do
    ReceiveAmount.delete_all
    CSV.foreach('receive_amounts.csv', :headers => true) do |row|
      ReceiveAmount.create!(row.to_hash)
    end
  end

  desc "import ufafees"
  task :ufafees => :environment do
    Ufafee.delete_all
    CSV.foreach('ufafees.csv', :headers => true) do |row|
      Ufafee.create!(row.to_hash)
    end
  end

  desc "import users"
  task :users => :environment do
    User.delete_all
    CSV.foreach('users.csv', :headers => true) do |row|
      User.create!(row.to_hash)
    end
  end
end