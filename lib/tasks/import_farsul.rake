
namespace :import do

  desc "Taxpayers"
  task :taxpayers => :environment do

	require 'pry'

  	db = Mdb.open('gma.mdb')

  	a_termo_b = db[:a_termo_b]

  	a_termo_b.each do |data|

  		name_city  = data[:C_CIDADE]
  		state = data[:C_UF]
  		cnpj_cpf = data[:CPFCGC]
  		name = data[:NOME_SAC]
  		address = data[:C_ENDSAC]
  		zipcode = data[:C_CEP]
  		origin_code = data[:CODIGO]

			_cpf = nil
			_cnpj = nil


  		ActiveRecord::Base.transaction do

  			city_id = import_city(name_city, state)

	  		t = Taxpayer.new(:cpf => cnpj_cpf, :cnpj => cnpj_cpf)

	  		if t.cpf.valido?
		  		_cpf = t.cpf.numero
		  		taxpayer = Taxpayer.where('cpf = ?', _cpf)
		  	end

		  	if t.cnpj.valido?
		  		_cnpj = t.cnpj.numero
		  		taxpayer = Taxpayer.where('cnpj = ?', _cnpj)
		  	end

	  		if taxpayer.size == 0 

	  			taxpayer = Taxpayer.new
					taxpayer.name = name
					taxpayer.cpf = _cpf
					taxpayer.cnpj = _cnpj
					taxpayer.zipcode = zipcode
					taxpayer.state = state
					taxpayer.address = address
					taxpayer.unit_id = 1
					taxpayer.client_id = 2
					taxpayer.city_id = city_id
					taxpayer.complement = ''
					taxpayer.neighborhood = ''
					taxpayer.origin_code = origin_code

					taxpayer.save!
				end
	  	end
  	end

	end


	private
	def import_city(_name, _state)

		city = City.where('name = ? AND state = ?', _name, _state)[0]

		unless city
			city = City.new
			city.name = name_city
			city.state = state
			city.unit_id = 1
			city.fl_charge = false
			city.save!
		end

		city.id

	end

end
