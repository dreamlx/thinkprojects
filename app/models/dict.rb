class Dict < ActiveRecord::Base
   
  has_many :people
  has_many :clients
  has_many :projects
  has_many :overtimes

   def self.search_by_sql(search,page = 1)
    paginate :per_page => 20, :page => page,
      :conditions=>search
  end
end
