require 'lighthouse-api'

class Ticket < ActiveRecord::Base
  belongs_to :user
#  acts_as_list :scope => :category
  
end


