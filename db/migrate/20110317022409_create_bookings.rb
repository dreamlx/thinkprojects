class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.integer :person_id
      t.integer :hours, :default => 0
      t.text :other

      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
