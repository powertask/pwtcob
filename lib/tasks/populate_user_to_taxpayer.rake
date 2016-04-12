namespace :populate_user_to_taxpayer do

  desc "Populate"
  task :redistributed => :environment do

    users = User.user.where('fl_taxpayer = ?', true)

    total_distributed = users.count * 100
    user_index = 0
    total      = 0

    taxpayers = Cna.find_by_sql('select t.id, t.distributed_at, sum(c.amount) from cnas c, taxpayers t where c.taxpayer_id = t.id  group by t.id, t.distributed_at order by 3 DESC')
    
    ActiveRecord::Base.transaction do
      taxpayers.each do |taxpayer|
        
        if total_distributed >= total

          history = History.find_by_sql(['select max(history_date) history_at from histories where taxpayer_id = ?', taxpayer.id ]).first

        
          if taxpayer.distributed_at + 60.days < Date.current
      
            if history.history_at.nil? or history.history_at < taxpayer.distributed_at
      
              t = Taxpayer.find(taxpayer.id)

              d = Redistributed.new
              d.taxpayer_id = taxpayer.id
              d.distributed_at = Time.current
              d.user_prev_id = t.user_id
              d.user_id = users[user_index].id
              d.unit_id = t.unit_id
              d.save!

              t.user_id = users[user_index].id
              t.save!


              user_index = user_index + 1
              total = total + 1

              if user_index == users.count
                user_index = 0
              end
            end
          end
        end
      end
    end
  end
end

