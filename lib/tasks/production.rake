namespace :production do

  desc "Tasks"
  task :create_tasks => :environment do

    users = User.user.where('fl_taxpayer = ?', true)

    users.each do |user|
    
      taxpayers = Cna.find_by_sql(['select t.id, t.name, sum(c.amount) amount from cnas c, taxpayers t, cities ct where c.taxpayer_id = t.id AND t.city_id = ct.id AND t.user_id = ? AND c.status = 0 AND ct.fl_charge = ? AND not exists(select 1 from histories h where h.taxpayer_id = t.id) group by t.id, t.name order by 3 DESC LIMIT 10', user.id, true])

      if taxpayers.present?
        taxpayers.each do |taxpayer|
          t = Task.new
          t.task_date = Date.current
          t.description = 'Entrar em contato com -- ' << taxpayer.name.upcase << ' -- Valor CNAs R$ ' << taxpayer.amount.real.to_s
          t.unit_id = user.unit_id
          t.user_id = user.id
          t.taxpayer_id = taxpayer.id
          t.status = 0  # Call
          t.save!
        end
      end
    end
  end
end

