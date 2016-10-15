namespace :fix_contract do

	desc "Fix contracts description"
	task :description => :environment do
    
    contracts = Contract.all.order('id')

    contracts.each do |contract|

      cnas = Cna.where('contract_id = ?', contract.id).order('year')

      unless cnas.nil?
        description = ''
        cnas.each do |cna|
          description << '-' unless description.empty?
          description << cna.year.to_s
        end
      end
      
      unless description.empty?
        contract.description = description
        contract.save!
      end

    end
	end

end

