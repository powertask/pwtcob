namespace :bank_billet_sync do
  desc "bank billet sync"
    task :sync => :environment do
      bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 250)

		bank_billets.each do |i|
			if i.status != 'canceled' 
				ticket = Ticket.find_by(bank_billet_id: i.id)

				if ticket.present?
					bankbillet = BoletoSimples::BankBillet.find(ticket.bank_billet_id)

					if bankbillet.present?
						ActiveRecord::Base.transaction do
							bank_billet_pwt = BankBillet.new( :unit_id => 1, 
								                              :bank_billet_account_id => (ticket.ticket_type == 'client' ? 2 : 1), 
								                              :origin_code => bankbillet.id, 
								                              :our_number => bankbillet.our_number, 
								                              :amount => bankbillet.amount, 
								                              :expire_at => bankbillet.expire_at, 
								                              :customer_person_name => bankbillet.customer_person_name,
								                              :customer_cnpj_cpf => bankbillet.customer_cnpj_cpf,
								                              :status => (bankbillet.status == 'generating' ? 1 : bankbillet.status), 
								                              :shorten_url => bankbillet.formats["pdf"], 
								                              :fine_for_delay => bankbillet.fine_for_delay, 
								                              :late_payment_interest => bankbillet.late_payment_interest, 
								                              :document_date => bankbillet.document_date, 
								                              :document_amount => bankbillet.document_amount)
							bank_billet_pwt.save!
							ticket.bank_billet_id = bank_billet_pwt.id
							ticket.save!
						end
					end
				end
			end
		end
    end
end