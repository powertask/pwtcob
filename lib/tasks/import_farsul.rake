
namespace :import do

  desc "Farsul"
  task :farsul => :environment do

	require 'pry'

  	db = Mdb.open('gma.mdb')

 		ActiveRecord::Base.transaction do

	  	a_termo_b = db[:a_termo_b]

	  	a_termo_b.each do |data|

	  		name_city  = data[:C_CIDADE]
	  		state = data[:C_UF]
	  		cnpj_cpf = data[:CPFCGC]
	  		name = data[:NOME_SAC]
	  		address = data[:C_ENDSAC]
	  		zipcode = data[:C_CEP]
	  		origin_code_taxpayer = data[:CODIGO]
	  		amount_farsul = data[:FARSUL]
	  		amount_gma = data[:GMA]
	  		parc_farsul = data[:PARC_FARSUL]
	  		parc_gma = data[:PARC_GMA]
	  		contract_date = data[:DATA]

	  		origin_code_contract = data[:NRO_TERMO]

				city_id     = import_city(name_city, state)
				taxpayer_id = import_taxpayer(cnpj_cpf, name, zipcode, state, address, city_id, origin_code_taxpayer)
				contract_id = import_contract(origin_code_contract, taxpayer_id, amount_farsul, amount_gma, parc_farsul, parc_gma, contract_date)

	  	end

	  	a_termo = db[:a_termo]

	  	a_termo.each do |data|

	  		origin_code_taxpayer = data[:CODIGO]
	  		exercicio = data[:EXERCICIO]
	  		numero_doc = data[:NUMDOC]
	  		valor = data[:VALOR_CNA]

	  		cna_id = import_cna(origin_code_taxpayer, exercicio, numero_doc, valor)

	  	end

	  	a_termo_p_gma = db[:a_termo_p_gma]

	  	a_termo_p_gma.each do |data|

	  		origin_code_contract	=	data[:CODIGO]
	  		dt_criacao						=	data[:DATA]
	  		dt_vencimento					=	 data[:VENCIMENTO]
	  		valor 								= data[:VALOR]

	  		ticket_id = import_ticket(origin_code_contract, dt_criacao, dt_vencimento, valor)

	  	end

	  end
	end


	private


	def import_ticket(origin_code, dt_criacao, dt_vencimento, valor)

		ticket = Ticket.where('unit_id = ? and client_id = ? and contract_id = ? and due = ?', 1, 2, origin_code.to_i, dt_vencimento.to_date)

		if ticket.size == 0
			ticket = Ticket.new
			ticket.unit_id = 1
			ticket.contract_id = origin_code.to_i
    	ticket.ticket_type = 1
    	ticket.amount = valor.to_f
    	ticket.ticket_number = 1
    	ticket.due = dt_vencimento.to_date
    	ticket.status = 1
    	ticket.save!
    	return ticket.id
    end

    return ticket.first.id
	end


	def import_cna(origin_code, year, numero_doc, amount)

		taxpayer = Taxpayer.where('unit_id = ? and client_id = ? and origin_code = ?', 1, 2, origin_code.to_i)

		if taxpayer.size == 1

			cna = Cna.where('unit_id = ? and client_id = ? and taxpayer_id = ? and year = ?', 1, 2, taxpayer.first.id, year.to_i)
    
			if cna.size == 0
				cna = Cna.new
				cna.unit_id = 1
				cna.client_id = 2
				cna.taxpayer_id = taxpayer.first.id
				cna.year = year.to_i
				cna.nr_document = numero_doc
				cna.amount = amount.to_f
				cna.stage = 1
				cna.status = 0
				cna.fl_charge = false

				cna.save!
				return cna.id
			end

			return cna.first.id
		else
			raise	
		end
  end


	def import_contract(origin_code_contract, taxpayer_id, amount_farsul, amount_gma, parc_farsul, parc_gma, contract_date)
		
		contract = Contract.where('unit_id = ? and client_id = ? and origin_code = ?', 1, 2, origin_code_contract.to_i)

		if contract.size == 0
			contract = Contract.new
			contract.unit_id = 1
			contract.taxpayer_id = taxpayer_id
			contract.unit_amount = amount_gma.to_f
			contract.unit_ticket_quantity = parc_gma.to_i
			contract.client_amount = amount_farsul.to_f
			contract.client_ticket_quantity = parc_gma.to_i
			contract.contract_date = contract_date.to_date
			contract.status = 0
			contract.user_id = 3
			contract.client_id = 2
			contract.origin_code = origin_code_contract.to_i

			contract.save!

			return contract.id
		end

		return contract.first.id
	end


	def import_city(name, state)

		city = City.where('name = ? AND state = ?', name, state)[0]

		unless city
			city = City.new
			city.name = name
			city.state = state
			city.unit_id = 1
			city.fl_charge = true

			city.save!
		end
		city.id
	end


	def import_taxpayer(cnpj_cpf, name, zipcode, state, address, city_id, origin_code)

		_cpf = nil
		_cnpj = nil

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

			return taxpayer.id
		end

		return taxpayer.first.id
	end		

end
