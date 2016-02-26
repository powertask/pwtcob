namespace :bank_billet_status_sync do
  desc "bank billet status sync"
    task :sync => :environment do
    	bank_billet_pwt = BankBillet.where('status in (1,4)')

    	bank_billet_pwt.each do |i|
			bankbillet_api = BoletoSimples::BankBillet.find(i.origin_code)

			if bankbillet_api.present?
				bankbillet = BankBillet.find(i.id)
				ActiveRecord::Base.transaction do
					bankbillet.status = bankbillet_api.status
					bankbillet.paid_at = bankbillet_api.paid_at
					bankbillet.paid_amount = bankbillet_api.paid_amount
					bankbillet.fine_for_delay = bankbillet_api.fine_for_delay
					bankbillet.late_payment_interest = bankbillet_api.late_payment_interest
					bankbillet.save!
				end
			end
    	end
    end
end