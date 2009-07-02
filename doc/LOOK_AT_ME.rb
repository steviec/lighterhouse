class User
  
end

class Ticket
  belongs_to :user
  acts_as_list :scope => :user

  def user_id=(user_id)
    p = position
    remove_from_list if (p && valid?)
    super
    insert_at position_in_bounds(p) if (p && valid?)
  end

  private

  def position_in_bounds(pos)
    length = user.tickets.length
    length += 1 unless user.tickets.include? self
    if pos < 1
      1
    elsif pos > length
      length
    else
      pos
    end
  end
end
end