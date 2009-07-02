require 'lightouse-api'
Lighthouse.account = 'animoto'
Lighthouse.authenticate('stevie@animoto.com', PASSWORD)


# all tix for systems project
tt = Lighthouse::Project.find(:all)[9].tickets

# pre populate all tickets
tt.each{|t| u = User.find_by_lighthouse_id(t.assigned_user_id); new_ticket = Ticket.new(:title => t.title, :user_id => (u.nil? ? nil : u.id)); new_ticket.save }; puts