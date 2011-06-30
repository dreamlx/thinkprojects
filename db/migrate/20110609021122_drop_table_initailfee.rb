class DropTableInitailfee < ActiveRecord::Migration
  def self.up
  begin	drop_table "initialfees" rescue true end
	end

  def self.down
  end
end
