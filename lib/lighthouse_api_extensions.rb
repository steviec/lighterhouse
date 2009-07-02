
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
    
  def unique_id
    "#{prefix_options[:project_id]}-#{id}"
  end
  
  def scoped_cache_id
    unique_id
  end

  def throw_error
    raise "THROWING ERROR"
  end
  
  def priority_color
    case priority
    when 1
      '#B0B0B0'
    when 2
      '#D0D0D0'
    else
      '#EFEFEF'
    end
  end

end
