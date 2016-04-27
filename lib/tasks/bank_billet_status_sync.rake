namespace :bank_billet_status_sync do

  desc "bank billet status sync"

  task :sync => :environment do
#    bank_billet_pwt = BankBillet.where('status in (0,1,4)')
    bank_billet_pwt = BankBillet.all)

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
                ticket.paid! 
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
    end
  end
end