class ChangeUserOfClients < ActiveRecord::Migration
  def up
    add_column :clients, :user_id, :integer
    Client.all.each do |client|
      client.user_id = User.find_by_person_id(client.person_id).id
      client.save
    end
    remove_column :clients, :person_id
  end

  def down
    add_column :clients, :person_id, :integer
    Client.all.each do |client|
      client.person_id = User.find(client.user_id).person_id
      client.save
    end
    remove_column :clients, :user_id
  end
end
