# this shows callbacks system working fine w/ animoto ares models.
# WTF isn't it working with Lighthouse?

require 'active_resource'
require 'lib/active_resource_callbacks'

# Set the URL of the Animoto API, including HTTP basic authentication
ActiveResource::Base.site = 'http://web2-dev%40animoto.com@api-staging.animoto.com'
ActiveResource::Base.logger = Logger.new(STDOUT)

module Animoto
  class Project         < ActiveResource::Base
   include ActiveResource::Callbacks
   before_save :saving_message
    # include ActiveSupport::Callbacks
    # define_callbacks :before_save
    # before_save :saving_message
    def saving_message
      puts "ABOUT TO SAVE"
    end
  end
end

# In ActiveResource now, play around: create a new project
p = Animoto::Project.find('WYmjqV69hMuigJX6ZUXE6Q')

