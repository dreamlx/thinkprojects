class MoveContactsToClients < ActiveRecord::Migration
  def up
    Client.all.each do |client| 
      unless (client.person1    || client.title_1 || 
              client.gender1_id || client.mobile_1 || 
              client.tel_1      || client.fax_1 ||
              client.email_1    || client.address_1 ||
              client.city_1     || client.state_1 ||
              client.country_1  || client.postalcode_1) == ""
        contact1 = Contact.new
        contact1.client_id  = client.id
        if client.person1
          contact1.name       = client.person1
        else
          contact1.name       = "unnamed" 
        end
        if client.title_1
          contact1.title      = client.title_1
        else
          contact1.title      = "untitled"
        end
        if client.gender1_id
          contact1.gender     = client.gender1_id
        else
          contact1.gender     = "pending"
        end
        if client.mobile_1
          contact1.mobile     = client.mobile_1
        else
          contact1.mobile     = "pending"
        end

        if client.tel_1
          contact1.tel        = client.tel_1
        else
          contact1.tel        = "pending"
        end
        if client.fax_1
          contact1.fax        = client.fax_1
        else
          contact1.fax        = "pending"
        end
        if client.email_1
          contact1.email      = client.email_1
        else
          contact1.email      = "pending"
        end
        contact1.address    = client.address_1
        contact1.city       = client.city_1
        contact1.state      = client.state_1
        contact1.country    = client.country_1
        contact1.postalcode = client.postalcode_1
        contact1.other      = "nothing"
        contact1.save
      end

      unless (client.person2    || client.title_2 || 
              client.gender2_id || client.mobile_2 || 
              client.tel_2      || client.fax_2 ||
              client.email_2    || client.address_2 ||
              client.city_2     || client.state_2 ||
              client.country_2  || client.postalcode_2) == ""
        contact2 = Contact.new
        contact2.client_id  = client.id
        if client.person2
          contact2.name       = client.person2
        else
          contact2.name       = "unnamed" 
        end
        if client.title_2
          contact2.title      = client.title_2
        else
          contact2.title      = "untitled"
        end
        if client.gender2_id
          contact2.gender     = client.gender2_id
        else
          contact2.gender     = "pending"
        end
        if client.mobile_2
          contact2.mobile     = client.mobile_2
        else
          contact2.mobile     = "pending"
        end

        if client.tel_2
          contact2.tel        = client.tel_2
        else
          contact2.tel        = "pending"
        end
        if client.fax_2
          contact2.fax        = client.fax_2
        else
          contact2.fax        = "pending"
        end
        if client.email_2
          contact2.email      = client.email_2
        else
          contact2.email      = "pending"
        end
        contact2.address    = client.address_2
        contact2.city       = client.city_2
        contact2.state      = client.state_2
        contact2.country    = client.country_2
        contact2.postalcode = client.postalcode_2
        contact2.other      = "nothing"
        contact2.save
      end

      unless (client.person3    || client.title_3 || 
              client.gender3_id || client.mobile_3 || 
              client.tel_3      || client.fax_3 ||
              client.email_3) == ""
        contact3 = Contact.new
        contact3.client_id   = client.id
        if client.person3
          contact3.name       = client.person3
        else
          contact3.name       = "unnamed" 
        end
        if client.title_3
          contact3.title      = client.title_3
        else
          contact3.title      = "untitled"
        end
        if client.gender3_id
          contact3.gender     = client.gender3_id
        else
          contact3.gender     = "pending"
        end
        if client.mobile_3
          contact3.mobile     = client.mobile_3
        else
          contact3.mobile     = "pending"
        end

        if client.tel_3
          contact3.tel        = client.tel_3
        else
          contact3.tel        = "pending"
        end
        if client.fax_3
          contact3.fax        = client.fax_3
        else
          contact3.fax        = "pending"
        end
        if client.email_3
          contact3.email      = client.email_3
        else
          contact3.email      = "pending"
        end
        contact3.other      = "nothing"
        contact3.save
      end
    end

    change_table :clients do |t|
      t.remove :person1, :title_1, :mobile_1, :tel_1, :fax_1, :email_1, :gender1_id, :address_1, :city_1, :state_1, :country_1, :postalcode_1, 
               :person2, :title_2, :mobile_2, :tel_2, :fax_2, :email_2, :gender2_id, :address_2, :city_2, :state_2, :country_2, :postalcode_2, 
               :person3, :title_3, :mobile_3, :tel_3, :fax_3, :email_3, :gender3_id
    end
  end

  def down
    change_table :clients do |t|
      t.string :person1
      t.string :person2
      t.string :person3
      t.string :title_1
      t.string :title_2
      t.string :title_3
      t.string :mobile_1
      t.string :mobile_2
      t.string :mobile_3
      t.string :tel_1
      t.string :tel_2
      t.string :tel_3
      t.string :fax_1
      t.string :fax_2
      t.string :fax_3
      t.string :email_1
      t.string :email_2
      t.string :email_3
      t.string :gender1_id
      t.string :gender2_id
      t.string :gender3_id
      t.string :address_1
      t.string :address_2
      t.string :city_1
      t.string :city_2
      t.string :state_1
      t.string :state_2
      t.string :country_1
      t.string :country_2
      t.string :postalcode_1
      t.string :postalcode_2
    end
  end
end
