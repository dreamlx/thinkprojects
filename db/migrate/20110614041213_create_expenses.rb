class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :expense_category
      t.decimal :fee
      t.integer :project_id
      t.date :charge_date
      t.string :state
      t.string :desc, :default => ''
      t.integer :period_id
      t.timestamps
    end
    execute '
    insert into dicts (category,code,title ) values( "expense_type",2,"LOTRAN-Local transportation");
insert into dicts (category,code,title ) values( "expense_type",3,"OTMEAL-Meal for OT");
insert into dicts (category,code,title ) values( "expense_type",4,"OTTRAN-Local transportation-OT");
insert into dicts (category,code,title ) values( "expense_type",5,"GOVFEE-Government Fee");
insert into dicts (category,code,title ) values( "expense_type",6,"PROMGV-Government promotion (P&M only)");
insert into dicts (category,code,title ) values( "expense_type",7,"PROMCL-Client promotion (P&M only)");
insert into dicts (category,code,title ) values( "expense_type",8,"STFWEL-Staff Welfare (P&M only)");
insert into dicts (category,code,title ) values( "expense_type",9,"TLODGE-Travel: lodging");
insert into dicts (category,code,title ) values( "expense_type",10,"TMEAL -Travel: meal");
insert into dicts (category,code,title ) values( "expense_type",11,"TTRAN -Travel: transportation");
insert into dicts (category,code,title ) values( "expense_type",12,"TALLO - Travel: Allowance");
insert into dicts (category,code,title ) values( "expense_type",13,"COURIE- Courier");
insert into dicts (category,code,title ) values( "expense_type",14,"AIRTIC-Air Ticket");
insert into dicts (category,code,title ) values( "expense_type",15,"TRAINT-Train Ticket");
insert into dicts (category,code,title ) values( "expense_type",16,"OTHER -Others (please specify nature)"); 
    '
  end

  def self.down
  end
end
