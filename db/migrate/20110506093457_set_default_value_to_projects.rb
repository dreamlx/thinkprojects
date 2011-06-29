class SetDefaultValueToProjects < ActiveRecord::Migration
  def self.up
    execute "update projects,dicts set state ='closed'  where projects.status_id = dicts.id and dicts.category like 'prj_status' and dicts.title like 'Closed';"
    execute "update projects,dicts set state ='approved'  where projects.status_id = dicts.id and dicts.category like 'prj_status' and dicts.title not like 'Closed';"
  end

  def self.down
  end
end
