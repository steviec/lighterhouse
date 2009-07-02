# ActiveResource callbacks
# http://deaddeadgood.com/2008/8/27/active-resource-callbacks

module ActiveResource
  module Callbacks
    CALLBACKS = %w( after_save before_save after_destroy before_destroy )
    
    def self.included(base)
      base.send :include, ActiveSupport::Callbacks
      base.define_callbacks *CALLBACKS
    end
    
    def save
      run_callbacks(:before_save)
      super
      run_callbacks(:after_save)
    end
    
    def destroy
      run_callbacks(:before_destroy)
      super
      run_callbacks(:after_destroy)
    end

  end
end

# ANIMOTO NOTE:
# This doesn't work for the Lighthouse API.  They must be doing some meta-magic
# that prevents this include from working, so I'm manually including on Lighthouse::Base
#ActiveResource::Base.send :include, ActiveResource::Callbacks