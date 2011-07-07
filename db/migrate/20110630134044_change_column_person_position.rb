class ChangeColumnPersonPosition < ActiveRecord::Migration
  def self.up
     rename_column :people, :grade, :position
  end

  def self.down
  end
end
