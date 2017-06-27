namespace :production do

  desc "email_taxpayer_in_debit"
  task :email_taxpayer_in_debit => :environment do
    AdminMailer.taxpayer_in_debit().deliver_now
    puts 'Email sending!'
  end


  desc "Clears Rails tmp"
  task :clear_tmp => :environment do
     Dir["tmp/*.zip"].each do |i|
      puts 'Deleting file ' + i
      File.delete(i)
     end
     puts 'task completed with sucess!'
  end

  
  ## Executar apos a atualizaco dos tickets
  desc "Update contract status"
  task :update_contract_status => :environment do
    
    contracts = Contract.active

    contracts.each do |contract|
      tickets_open = Ticket.where('contract_id = ? AND status in (0,1,4)', contract.id)

      ActiveRecord::Base.transaction do

        if tickets_open.empty?
          contract.status = :paid
          contract.save!

          cnas = Cna.where('contract_id = ?', contract.id)
          cnas.each do |cna|
            cna.status = :pay
            cna.save!
          end
        end
      end
    end
  end


  desc "Update ticket status"
  task :update_ticket_status => :environment do
    bank_billet_pwt = BankBillet.where('status in (1,4)')

    bank_billet_pwt.each do |i|
      bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

      if bankbillet_api.present?
        bankbillet = BankBillet.find(i.id)
        ticket     = Ticket.where('bank_billet_id = ?', i.id).first
        
        if ticket.present?
          contract   = Contract.find ticket.contract_id

          begin
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

              ticket.save!

              if bankbillet_api.paid_amount > 0
                ticket_not_paid = Ticket.where('contract_id = ? AND status in (0,1,4)', ticket.contract_id)
                if ticket_not_paid.empty?
                  contract.status = :paid
                  contract.save!
                end
              end

              if bankbillet.paid_amount > 0
                history = History.new
                history.description = 'Boleto ' << bankbillet.our_number.to_s << ' pago no valor de R$ ' << bankbillet.paid_amount.to_s
                history.history_date = Time.current
                history.unit_id = 1
                history.user_id = 1
                history.client_id = ticket.client_id
                history.taxpayer_id = contract.taxpayer_id
                history.save!
              end
            end
            rescue ActiveRecord::RecordInvalid => e
            puts e.record.errors.full_messages
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
      sleep(1.second)
    end
  end

  
  
  desc "Redistribute taxpayers"
  task :redistribute_taxpayers => :environment do

    users = User.user.where('fl_taxpayer = ?', true)

    total_distributed = users.count * 200
    user_index = 0
    total      = 0
    sum_dist = 0

    taxpayers = Cna.find_by_sql(['select t.id, t.distributed_at, sum(c.amount), t.user_id from cnas c, taxpayers t, cities ct where c.taxpayer_id = t.id AND c.status = 0 AND c.stage = 1 AND t.city_id = ct.id AND ct.fl_charge = ? group by t.id, t.distributed_at, t.user_id order by 3 DESC', true])
    
    begin
      ActiveRecord::Base.transaction do
        taxpayers.each do |taxpayer|
          
          if total_distributed >= total

            history = History.find_by_sql(['select max(history_date) history_at from histories where taxpayer_id = ?', taxpayer.id ]).first

            last_distributed_at = taxpayer.distributed_at
            last_distributed_at = Date.new(2000,1,1) if last_distributed_at.nil?

            if (last_distributed_at + 60.days < Date.current) or taxpayer.user_id.nil?
        
              if  history.history_at.nil? or 
                  last_distributed_at.nil? or 
                  history.history_at < last_distributed_at or
                  taxpayer.user_id.nil?
        
                t = Taxpayer.find(taxpayer.id)

                d = Redistributed.new
                d.taxpayer_id = taxpayer.id
                d.distributed_at = Time.current
                d.user_prev_id = t.user_id.nil? ? 1 : t.user_id
                d.user_id = users[user_index].id
                d.unit_id = t.unit_id
                d.save!

                t.user_id = users[user_index].id
                t.distributed_at = Time.current

                t.neighborhood = 'ND' if t.neighborhood.nil?

                t.save!

                sum_dist = sum_dist + 1

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

      rescue ActiveRecord::RecordInvalid => e
      puts e.record.errors.full_messages      
    end
    puts sum_dist.to_s
  end

end

 
