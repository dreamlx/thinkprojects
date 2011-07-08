class Expense < ActiveRecord::Base

  validates_presence_of :charge_date
  validates_presence_of :type
  validates_numericality_of :fee

  belongs_to :project
  belongs_to :period
  belongs_to :person
  
  state_machine :initial => :pending do
    event :approval do
      transition all =>:approved
    end
    event :disapproval do
      transition all => :disapproved
    end
    event :close do
      transition all => :closed
    end
    event :transform do
      transition :approval => :transformed
    end
    event :reset do
      transition all => :pending
    end
  end

  def self.paginate_by_sql(search,page = 1, order_str = " created_at ")
    paginate :per_page => 20, :page => page,
      :conditions=>search,
      :joins=>" left join projects on project_id = projects.id left join clients on client_id = clients.id",
      :order=>order_str
  end


end
