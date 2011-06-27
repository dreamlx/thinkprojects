class InsertDefaultUserToUsers < ActiveRecord::Migration
  def self.up
	execute "UPDATE  `users` SET  `roles` =  'providence_breaker' WHERE  `users`.`login` ='admin';"
  end

  def self.down
  end
end
