# TODO
# can't successfully save, then reload
# tried to override methods in cached_resource, but to no avail
# try
# 1) getting the ARes callbacks to work (save is successful, but doesn't call raise_error in Ticket)
# 2) getting the #reload call to work

# NOTE
# reload broken.  When getting tickets, it calls "load", which expects any nested collection
# to be attribute hashes.  Instead, it gets an array of Ticket::Versions, which causes
# ARes to barf.

require 'vendor/plugins/lighthouse-api/lib/lighthouse-api'
# require 'vendor/plugins/cache_fu/init'
# require 'vendor/plugins/cached_resource/init'

Lighthouse.account = 'animoto'
Lighthouse.authenticate('stevie@animoto.com', PASSWORD)

class Lighthouse::Ticket
#  cached_resource :cache_id => :scoped_cache_id
#  before_save :expire_cache
  
  # def reload_with_cache
  #   expire_cache
  #   get_cache do
  #     self.reload_without_cache
  #   end
  # end
  # alias_method_chain :reload, :cache
    
  def scoped_cache_id
    "#{prefix_options[:project_id]}_#{id}"
  end

  def throw_error
    raise "THROWING ERROR"
  end

end

module Lighthouse
  class Project
#  cached_resource
    def all_tickets(options = {})
      tickets = []
      i = 0
      begin
        options[:page] = i+=1
        tt = Ticket.find(:all, :params => options.update(:project_id => id))
        tickets += tt
        puts "PAGE: #{i}"
      end while !tt.blank?
      tickets
    end

  end
end


ActiveResource::Base.logger = Logger.new(STDOUT)
pp = Lighthouse::Project.find(:all)
t = pp[9].tickets[0]
t.title = 'Update FB/Web2 with new Mongrel health check'


