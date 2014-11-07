class Industry < ActiveRecord::Base
  has_many :clients
  attr_accessible :code, :title

  def self.selected_industries
    all.map {|i| ["#{i.code}||#{i.title}", i.id]}
  end
end