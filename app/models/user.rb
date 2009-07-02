class User < ActiveRecord::Base
  has_many :tickets, :order => :position
end
