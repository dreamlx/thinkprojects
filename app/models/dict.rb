class Dict < ActiveRecord::Base
   
  has_many :people
  has_many :clients
  has_many :projects
  has_many :overtimes

  named_scope :GMU, :conditions => "category ='GMU'", :order=>'code'
  named_scope :department, :conditions => "category = 'department'", :order=>'code'
  named_scope :expense_types, :conditions => "category = 'expense_type'", :order=>'code'
  def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end


end
