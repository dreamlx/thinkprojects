class Dict < ActiveRecord::Base
   
  has_many :people
  has_many :clients
  has_many :projects
  has_many :overtimes

  scope :GMU,           :conditions => "category ='GMU'", :order=>'code'
  scope :department,    :conditions => "category = 'department'", :order=>'code'
  scope :expense_types, :conditions => "category = 'expense_type'", :order=>'code'

  def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end

  def self.get_forward(code='')
    self.where(:conditions => " code like '#{code}%'")
  end
end
