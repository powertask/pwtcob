namespace :production do

  desc "Tasks"
  task :create_tasks => :environment do

    users = User.user.where('fl_taxpayer = ?', true)

    users.each do |user|
    
      # Somente FAESC
      taxpayers = Cna.find_by_sql(['select t.id, t.name, sum(c.amount) amount from cnas c, taxpayers t, cities ct where c.taxpayer_id = t.id AND t.client_id = 1 AND t.city_id = ct.id AND t.user_id = ? AND c.status = 0 AND ct.fl_charge = ? AND not exists(select 1 from histories h where h.taxpayer_id = t.id) group by t.id, t.name order by 3 DESC LIMIT 10', user.id, true])

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

  desc "Clears Rails tmp"
  task :clear_tmp => :environment do
     Dir["tmp/*.zip"].each do |i|
      puts 'Deleting file ' + i
      File.delete(i)
     end
     puts 'task completed with sucess!'
  end


  desc "Update ticket status"
  task :update_ticket_status => :environment do
    bank_billet_pwt = BankBillet.where('status in (1,4)')
#    bank_billet_pwt = BankBillet.all

    bank_billet_pwt.each do |i|
      bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

      if bankbillet_api.present?
        bankbillet = BankBillet.find(i.id)
        ticket     = Ticket.where('bank_billet_id = ?', i.id).first
        
        if ticket.present?
          contract   = Contract.find ticket.contract_id

          ActiveRecord::Base.transaction do
            bankbillet.status = bankbillet_api.status
            bankbillet.paid_at = bankbillet_api.paid_at
            bankbillet.paid_amount = bankbillet_api.paid_amount
            bankbillet.fine_for_delay = bankbillet_api.fine_for_delay
            bankbillet.late_payment_interest = bankbillet_api.late_payment_interest
            bankbillet.save!

            ticket.status = bankbillet_api.status
            ticket.paid_at = bankbillet_api.paid_at
            ticket.paid_amount = bankbillet_api.paid_amount

            if ticket.paid_amount > 0
              ticket_not_paid = Ticket.where('contract_id = ? AND status in (0,1,4)', ticket.contract_id)
              if ticket_not_paid.empty?
                contract.status = 2 #Paid 
                contract.save!
              end
            end

            ticket.save!


            if bankbillet.paid_amount > 0
              history = History.new
              history.description = 'Boleto ' << bankbillet.our_number.to_s << ' pago no valor de R$ ' << bankbillet.paid_amount.to_s
              history.history_date = Time.current
              history.unit_id = 1
              history.taxpayer_id = contract.taxpayer_id
              history.save!
            end
          end
        end
      end
      sleep(1.second)
    end
  end


  
  
  desc "Update ticket status 0"
  task :update_ticket_status_generated => :environment do
    bank_billet_pwt = BankBillet.where('status = ?', 0)

    bank_billet_pwt.each do |i|
      bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

      if bankbillet_api.present?
        bankbillet = BankBillet.find(i.id)
        ticket     = Ticket.where('bank_billet_id = ?', i.id).first
        
        if ticket.present?
          ActiveRecord::Base.transaction do
            bankbillet.status = bankbillet_api.status
            bankbillet.save!

            ticket.status = bankbillet_api.status
            ticket.save!
          end
        end
      end
    end
  end

  
  
  desc "Redistribute taxpayers"
  task :redistribute_taxpayers => :environment do

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
              t.distributed_at = Time.current
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

 
