class Industry < ActiveRecord::Base
  has_many :clients
  attr_accessible :code, :title
end
