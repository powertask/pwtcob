namespace :bank_billet_status_sync do
  desc "bank billet status sync"
    task :sync => :environment do
    	bank_billet_pwt = BankBillet.where('status in (0,1,2,3,4,5,6)')

    	bank_billet_pwt.each do |i|
			bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

			if bankbillet_api.present?
				bankbillet = BankBillet.find(i.id)
				ActiveRecord::Base.transaction do
					bankbillet.status = bankbillet_api.status
					bank_billet.status = bankbillet.status
					bank_billet.paid_at = bankbillet.paid_at
					bank_billet.paid_amount = bankbillet.paid_amount
					bank_billet.fine_for_delay = bankbillet.fine_for_delay
					bank_billet.late_payment_interest = bankbillet.late_payment_interest
					bankbillet.save!
				end
			end
    	end
    end
end