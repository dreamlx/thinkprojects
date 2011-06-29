class AddValueToDicts < ActiveRecord::Migration
  def self.up
    execute "INSERT INTO `project_mis`.`dicts` (`id`, `category`, `code`, `title`)
              VALUES (NULL, 'prj_status', '2', 'hold');"
    execute "INSERT INTO `project_mis`.`dicts` (`id`, `category`, `code`, `title`)
              VALUES (NULL, 'mgcc', '3', 'approval');"
    execute "INSERT INTO `project_mis`.`dicts` (`id`, `category`, `code`, `title`)
              VALUES (NULL, 'prj_status', '4', 'disapproval');"
    
  end

  def self.down
  end
end
