class InsertDefaultUserToUsers2 < ActiveRecord::Migration
  def self.up
	execute "UPDATE  `users` SET  `roles` =  'providence_breaker' WHERE  `users`.`login` ='zxnicv';"
  end

  def self.down
  end
end
