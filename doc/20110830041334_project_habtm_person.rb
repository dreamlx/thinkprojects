class ProjectHabtmPerson < ActiveRecord::Migration
  def self.up
    create_table "projects_managers", :force => true do |t|
      t.integer :project_id
      t.integer :manager_id
    end
    
    create_table "projects_partners", :force => true do |t|
      t.integer :project_id
      t.integer :partner_id
    end
  end

  def self.down
  end
end
