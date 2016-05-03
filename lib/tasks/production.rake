namespace :production do

  desc "Tasks"
  task :create_tasks => :environment do

    users = User.user.where('fl_taxpayer = ?', true)

    users.each do |user|
    
      taxpayers = Cna.find_by_sql(['select t.id, t.name, sum(c.amount) amount from cnas c, taxpayers t where c.taxpayer_id = t.id AND t.user_id = ? AND not exists(select 1 from histories h where h.taxpayer_id = t.id) group by t.id, t.name order by 3 DESC LIMIT 10', user.id])

      taxpayers.each do |taxpayer|
        description = 'Ligar para ' << taxpayer.name.upcase << '(Sem historico) - Valor CNAs: R$ ' << taxpayer.amount.real.to_s

        t = Task.new
        t.task_date = Date.current
        t.description = description
        t.unit_id = user.unit_id
        t.taxpayer_id = taxpayer.id
        t.user_id = user.id

        t.save!
      end
    end
  end
end

