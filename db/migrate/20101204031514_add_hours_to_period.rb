class AddHoursToPeriod < ActiveRecord::Migration
  def self.up
     add_column :periods, :hours , :integer,:default =>0
  #optional, but it could help depending on your site
  #add_index "posts", "user_id"
  end

  def self.down
  end
end
