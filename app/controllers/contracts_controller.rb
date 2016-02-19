class ContractsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    if current_user.admin?
      @contracts = Contract.where("unit_id = ?", session[:unit_id]).paginate(:page => params[:page], :per_page => 20)
    else
      @contracts = Contract.where("unit_id = ? AND employee_id = ?", session[:unit_id], current_user.employee_id).paginate(:page => params[:page], :per_page => 20)
    end
    respond_with @contracts, :layout => 'application'
  end

  def show
    @contract = Contract.find(params[:id])
    @tickets = Ticket.list(session[:unit_id]).where("contract_id = ?", params[:id])
    respond_with @contract
  end

  def create_contract
    cod = params[:cod]

    taxpayer = Taxpayer.find(cod)
    cnas = Cna.list(session[:unit_id]).not_pay.where('taxpayer_id = ? and fl_charge = ?', cod, true)
    unit = Unit.find(session[:unit_id])

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = session[:unit_id]
      @contract.contract_date = Time.now
      @contract.taxpayer_id = cod
      @contract.employee_id = current_user.employee_id
      
      if session[:tickets].count == 2
        unit_amount = session[:total_fee_a_vista].to_f
        @contract.unit_amount = unit_amount.round(2)

        client_amount = session[:total_cna_a_vista].to_f - session[:total_fee_a_vista].to_f
        @contract.client_amount = client_amount.round(2)
        
        @contract.client_ticket_quantity = 1

      else
        unit_amount = session[:total_fee_cobrado].to_f
        @contract.unit_amount = unit_amount.round(2)

        client_amount = session[:total_cna_cobrado].to_f - session[:total_fee_cobrado].to_f
        @contract.client_amount = client_amount.round(2)
        
        @contract.client_ticket_quantity = session[:tickets].count - 1
      end
      
      @contract.unit_ticket_quantity = 1
      @contract.unit_fee = 10
      @contract.status = 0

      @contract.save!

      n = 0
      session[:tickets].each  do |tic|
        n = n + 1
        @ticket = Ticket.new
        @ticket.unit_id = session[:unit_id]
        @ticket.contract_id = @contract.id
        @ticket.ticket_type = 0 if tic['unit_amount'].to_f == 0
        @ticket.ticket_type = 1 if tic['unit_amount'].to_f > 0
        
        @ticket.amount = tic['client_amount'].to_f if tic['client_amount'].to_f > 0
        @ticket.amount = tic['unit_amount'].to_f if tic['unit_amount'].to_f > 0
        
        @ticket.due = tic['due'].to_date
        @ticket.ticket_number = n

        @ticket.save!
      end

      cnas.each do  |cna|
        cna.contract_id = @contract.id
        cna.contract!
        cna.save!
      end
    end

    respond_with @contract, notice: 'Termo criado com sucesso.'

  end

  def delete_contract
    contract = params[:contract]

    contract = Contract.find(contract)
    cnas     = Cna.where('contract_id = ?', contract)
    tickets  = Ticket.where('contract_id = ?', contract)


    ActiveRecord::Base.transaction do

      cnas.each do  |cna|
        cna.contract_id = nil
        cna.not_pay!
        cna.save!
      end

      contract.cancel!

    end

    redirect_to(controller: 'contracts', action:'index')

  end


  def contract_pdf
    unit = Unit.find(session[:unit_id])
    contract = Contract.find(params[:cod])
    tickets = Ticket.list(session[:unit_id]).where("contract_id = ?", params[:cod]).order('due')
    cnas = Cna.list(session[:unit_id]).where("contract_id = ?", params[:cod]).order('year')

    respond_to do |format|
      format.pdf do
      pdf = ContractPdf.new(unit, contract, tickets, cnas, view_context)
      send_data pdf.render, filename: contract.taxpayer.origin_code.to_s << " - " << contract.taxpayer.name,
                            type: "application/pdf",
                            disposition: "attachment"
      end
    end
  end

  def contract_transaction_pdf
    unit = Unit.find(session[:unit_id])
    contract = Contract.find(params[:cod])
    tickets = Ticket.list(session[:unit_id]).where("contract_id = ?", params[:cod]).order('due')
    cnas = Cna.list(session[:unit_id]).where("contract_id = ?", params[:cod]).order('year')

    respond_to do |format|
      format.pdf do
      pdf = ContractTransactionPdf.new(unit, contract, tickets, cnas, view_context)
      send_data pdf.render, filename: contract.taxpayer.name << " - Termo de Acordo.PDF",
                            type: "application/pdf",
                            disposition: "attachment"
      end
    end
  end

  def create_bank_billet
    ticket = Ticket.find(params[:cod])

    if ticket.bank_billet_id.blank? || ticket.bank_billet_id.nil?
      @contract = Contract.find(ticket.contract_id)
      taxpayer = Taxpayer.find(@contract.taxpayer_id)
      cna = Cna.select('year').where('contract_id = ?', ticket.contract_id)

      if taxpayer.cpf.present?
        cnpj_cpf = taxpayer.cpf.to_s
      else
        cnpj_cpf = taxpayer.cnpj.to_s
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
                          customer_neighborhood: taxpayer.neighborhood,
                          customer_person_name: taxpayer.name,
                          customer_person_type: 'individual',
                          customer_state: taxpayer.city.state,
                          customer_zipcode: taxpayer.zipcode,
                          bank_billet_account_id: 21,
                          instructions: 'Parcela ' << ticket.ticket_number.to_s << ' referente ao(s) ano(s) de ' << cna.collect {|i| i.year}.sort.join(',')
                        })

        if bank_billet.persisted?
          ticket.bank_billet_id = bank_billet.id
          ticket.save!
          redirect_to bank_billet.formats["pdf"]
        else
          puts "Erro :("
          puts bank_billet.response_errors
        end
      end
    else
      @contract = Contract.find(ticket.contract_id)
      bank_billet = BoletoSimples::BankBillet.find(ticket.bank_billet_id)
      redirect_to bank_billet.formats["pdf"]
    end
  end

  private
  def contract_params
    params.require(:contract).permit( :unit_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
