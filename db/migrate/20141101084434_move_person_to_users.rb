class MovePersonToUsers < ActiveRecord::Migration
  def up
    add_column :billings, :user_id, :integer
    Billing.all.each do |billing|
      if User.find_by_person_id(billing.person_id)
        billing.user_id = User.find_by_person_id(billing.person_id).id
        billing.save
      end
    end
    remove_column :billings, :person_id

    add_column :bookings, :user_id, :integer
    Booking.all.each do |booking|
      if User.find_by_person_id(booking.person_id)
        booking.user_id = User.find_by_person_id(booking.person_id).id
        booking.save
      end
    end
    remove_column :bookings, :person_id

    add_column :personalcharges, :user_id, :integer
    Personalcharge.all.each do |personalcharge|
      if User.find_by_person_id(personalcharge.person_id)
        personalcharge.user_id = User.find_by_person_id(personalcharge.person_id).id
        personalcharge.save
      end
    end
    remove_column :personalcharges, :person_id
  end

  def down
    add_column :billings, :person_id, :integer
    Billing.all.each do |billing|
      if billing.user_id
        billing.person_id = User.find(billing.user_id).person_id
        billing.save
      end
    end
    remove_column :billings, :user_id

    add_column :bookings, :person_id, :integer
    Booking.all.each do |booking|
      if booking.user_id
        booking.person_id = User.find(booking.user_id).person_id
        booking.save
      end
    end
    remove_column :bookings, :user_id

    add_column :personalcharges, :person_id, :integer
    Personalcharge.all.each do |personalcharge|
      if personalcharge.user_id
        personalcharge.person_id = User.find(personalcharge.user_id).person_id
        personalcharge.save
      end
    end
    remove_column :personalcharges, :user_id
  end
end
