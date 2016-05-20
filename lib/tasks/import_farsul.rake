
namespace :import do

  desc "Taxpayers"
  task :taxpayers => :environment do

  	db = Mdb.open('gma.mdb')

  	data = db[:a_termo_b]

  	data.each do |d|

  		name_city  = d[:C_CIDADE]
  		state = d[:C_UF]
  		cpf = d[:CPFCGC]
  		name = d[:NOME_SAC]
  		address = d[:C_ENDSAC]
  		zipcode = d[:C_CEP]

  		ActiveRecord::Base.transaction do
  			city = City.where('name = ? AND state = ?', name_city, state)[0]

	  		unless city
	  			city = City.new
	  			city.name = name_city
	  			city.state = state
	  			city.unit_id = 1
	  			city.fl_charge = false

	  			city.save!
	  		end

	  		taxpayer1 = Taxpayer.where('cpf = ?', cpf)
	  		taxpayer2 = Taxpayer.where('cnpj = ?', cpf)
	  		
	  		if taxpayer1.count == 0 and taxpayer2.count == 0

	  			taxpayer = Taxpayer.new
					taxpayer.name = name
					
					if cpf.size == 11
						taxpayer.cpf = cpf
					end

					if cpf.size == 14
						taxpayer.cnpj = cpf
					end

					taxpayer.zipcode = zipcode
					taxpayer.state = state
					taxpayer.address = address
					taxpayer.unit_id = 1
					taxpayer.client_id = 2
					taxpayer.city_id = city.id
					taxpayer.save!
				end
	  	end
  	end
	end
end
