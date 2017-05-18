class Ticket < ActiveRecord::Base
  belongs_to :unit
  belongs_to :bank_billet

  validates_presence_of :unit_id, :due, :contract_id, :ticket_type, :status

  enum ticket_type: [:client, :unit]
  enum status: [:generating, :opened, :canceled, :paid, :overdue, :blocked, :chargeback, :generation_failed]

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end


  def self.create_ticket(ticket_id)
    ticket = Ticket.find( ticket_id )

    if ticket.bank_billet_id.blank? || ticket.bank_billet_id.nil?
      contract = Contract.find(ticket.contract_id)
      taxpayer = Taxpayer.find(contract.taxpayer_id)
      client = Client.find(taxpayer.client_id)
      bank_billet_account = BankBilletAccount.find(client.bank_billet_account_id)
      bank_billet_account_unit = BankBilletAccount.find_by(bank_billet_account: session[:unit_bank_billet_account])
      cna = Cna.select('year').where('contract_id = ?', ticket.contract_id)

      t = Taxpayer.new(:cnpj => taxpayer.cnpj, :cpf => taxpayer.cpf)
      
      unless t.cnpj.nil?
        if t.cnpj.valido?
          cnpj_cpf = taxpayer.cnpj.to_s
        end
      end
      
      unless t.cpf.nil?
        if t.cpf.valido?
          cnpj_cpf = taxpayer.cpf.to_s
        end
      end

      ActiveRecord::Base.transaction do
        bank_billet = BoletoSimples::BankBillet.create({
                          amount: ticket.amount,
                          description: 'Servicos prestados conforme contrato',
                          expire_at: ticket.due,
                          customer_address: taxpayer.address,
                          customer_address_complement: taxpayer.complement,
                          customer_city_name: taxpayer.city.name,
                          customer_cnpj_cpf: cnpj_cpf,
                          customer_neighborhood: taxpayer.neighborhood.nil? ? ' ' : taxpayer.neighborhood,
                          customer_person_name: taxpayer.name,
                          customer_person_type: 'individual',
                          customer_state: taxpayer.city.state,
                          customer_zipcode: taxpayer.zipcode,
                          bank_billet_account_id: (ticket.ticket_type == 'client' ? bank_billet_account.bank_billet_account : bank_billet_account_unit.bank_billet_account),
                          instructions: 'Parcela ' << ticket.ticket_number.to_s << ' referente ao(s) ano(s) de ' << cna.collect {|i| i.year}.sort.join(',')
                        })

        if bank_billet.persisted?
          
          bank_billet_pwt = BankBillet.new( :unit_id => current_user.unit_id, 
                                            :bank_billet_account_id => (ticket.ticket_type == 'client' ? bank_billet_account.id : bank_billet_account_unit.id), 
                                            :origin_code => bank_billet.id, 
                                            :our_number => bank_billet.our_number, 
                                            :amount => bank_billet.amount, 
                                            :expire_at => bank_billet.expire_at, 
                                            :customer_person_name => bank_billet.customer_person_name,
                                            :customer_cnpj_cpf => bank_billet.customer_cnpj_cpf,
                                            :status => (bank_billet.status == 'generating' ? 0 : bank_billet.status), 
                                            :shorten_url => bank_billet.formats["pdf"], 
                                            :fine_for_delay => bank_billet.fine_for_delay, 
                                            :late_payment_interest => bank_billet.late_payment_interest, 
                                            :document_date => bank_billet.document_date, 
                                            :document_amount => bank_billet.document_amount)

          bank_billet_pwt.save!

          ticket.bank_billet_id = bank_billet_pwt.id
          ticket.status = 0  # Gerando
          ticket.save!

        else
          puts "Erro :("
          puts bank_billet.response_errors
        end
        ticket.bank_billet.shorten_url
      end
    end
  end
end
