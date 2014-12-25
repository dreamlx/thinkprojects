class Dict < ActiveRecord::Base
  has_many :users

  def self.get_forward(code='')
    where(" code like '#{code}%'")
  end

  def self.selected_expense_types
    where(category: 'expense_type').order('code').map {|p| [ p.title, p.title ] }
  end

  def self.selected_categories
    where(category: 'client_category').order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
  end

  def self.selected_statuses
    where(category: 'client_status').order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
  end

  def self.selected_regions
    where(category: 'region').order("code").map {|d| ["#{d.code}||#{d.title}", d.id]}
  end

  def self.selected_genders
    where(category: 'gender').order("code")
  end

  def self.selected_gmus
    where(category: 'GMU').order("code").map {|p| [ "#{p.code} || #{p.title}", p.id ] }
  end

  def self.selected_deps
    where(category: 'department').order("code").map {|p| [ "#{p.code} || #{p.title}", p.id ] }
  end

  def self.selected_service_codes
    where(category: 'service_code').order("code").map {|p| [ "#{p.code} || #{p.title}", p.id ] }
  end

  def self.selected_person_status
    where(category: 'person_status').map {|p| [ p.title, p.id ] }
  end
end
