class ContractsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html
  layout 'window'

  def index
    if current_user.admin? || current_user.client?
      @contracts = Contract.where("unit_id = ? AND client_id = ?", current_user.unit_id, session[:client_id]).order('contract_date DESC').paginate(:page => params[:page], :per_page => 20)
    else
      @contracts = Contract.where("unit_id = ? AND client_id = ? AND user_id = ?", current_user.unit_id, session[:client_id], current_user.id).order('contract_date DESC').paginate(:page => params[:page], :per_page => 20)
    end
    respond_with @contracts, :layout => 'application'
  end

  def show
    @contract = Contract.where('id = ? AND unit_id = ? AND client_id = ?', params[:id].to_i, current_user.unit_id, session[:client_id]).first
    @tickets = Ticket.list(current_user.unit_id).where("contract_id = ?", params[:id]).order('ticket_number')
    respond_with @contract
  end

  def create_contract
    cod = params[:cod]

    taxpayer = Taxpayer.find(cod)
    cnas = Cna.list(current_user.unit_id, session[:client_id]).not_pay.where('taxpayer_id = ? and fl_charge = ?', cod, true).order('year')
    unit = Unit.find(current_user.unit_id)


    description = ''

    cnas.each do |c|
      description << '-' unless description.empty?
      description << c.year.to_s
    end

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = current_user.unit_id
      @contract.client_id = session[:client_id]
      @contract.contract_date = Time.current
      @contract.taxpayer_id = cod
      @contract.user_id = current_user.id
      

      client_amount = 0
      unit_amount   = 0
      session[:tickets].each  do |tic|
        client_amount = client_amount + tic['client_amount'].to_f if tic['client_amount'].to_f > 0
        unit_amount   = unit_amount + tic['unit_amount'].to_f if tic['unit_amount'].to_f
      end

      @contract.unit_amount = unit_amount.round(2)
      @contract.client_amount = client_amount.round(2)
      @contract.client_ticket_quantity = session[:tickets].count - 1
      @contract.unit_ticket_quantity = 1

      @contract.unit_fee = 10
      @contract.status = 0

      @contract.description = description

      @contract.save!

      n = 0
      session[:tickets].each  do |tic|
        n = n + 1
        ticket = Ticket.new
        ticket.unit_id = current_user.unit_id
        ticket.contract_id = @contract.id
        ticket.ticket_type = 0 if tic['unit_amount'].to_f == 0
        ticket.ticket_type = 1 if tic['unit_amount'].to_f > 0
        
        ticket.amount = tic['client_amount'].to_f if tic['client_amount'].to_f > 0
        ticket.amount = tic['unit_amount'].to_f if tic['unit_amount'].to_f > 0
        
        ticket.due = tic['due'].to_date
        ticket.ticket_number = n
        ticket.status = 0

        ticket.save!
      end

      cnas.each do  |cna|
        cna.contract_id = @contract.id
        cna.contract!
        cna.save!
      end
    end

    respond_with @contract, notice: 'Termo criado com sucesso.'

  end

  def create_ticket

    t = Ticket.find params[:cod]

    ticket = Ticket.new
    ticket.unit_id = t.unid_id
    ticket.contract_id = t.contract_id
    ticket.ticket_type = t.ticket_type
    ticket.amount = t.amount
    ticket.due = t.due
    ticket.ticket_number = t.ticket_number
    ticket.save!

  end


  def create_contract_from_proposal
    cod = params[:cod]
    proposal = Proposal.find cod

    if proposal.contract?
      flash[:alert] = "Ação não permitida. Proposta ja gerou um TERMO NRO " << proposal.contract_id.to_s
      redirect_to :proposals and return
    end 

    cnas = Cna.list(current_user.unit_id, session[:client_id]).where('proposal_id = ?', cod)
    unit = Unit.find(current_user.unit_id)
    tickets = ProposalTicket.where('proposal_id = ?', cod)

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = current_user.unit_id
      @contract.client_id = session[:client_id]
      @contract.contract_date = Time.current
      @contract.taxpayer_id = proposal.taxpayer_id
      @contract.user_id = current_user.id
      @contract.status = 0
      @contract.unit_fee = 10


      unit_amount = 0
      client_amount = 0

      tickets.each  do |tic|
        unit_amount = unit_amount + tic['amount'].to_f if tic['ticket_number'] == 1
        client_amount = client_amount + tic['amount'].to_f if tic['ticket_number'] > 1
      end

      @contract.unit_amount = unit_amount.round(2)
      @contract.unit_ticket_quantity = 1
      @contract.client_amount = client_amount.round(2)
      @contract.client_ticket_quantity = tickets.size - 1
      @contract.proposal_id = cod

      @contract.save!


      tickets.each  do |tic|
        ticket = Ticket.new
        ticket.unit_id = current_user.unit_id
        ticket.contract_id = @contract.id

        ticket.ticket_type = tic['ticket_type']
        ticket.amount = tic['amount'].to_f
        ticket.due = tic['due_at'].to_date
        ticket.ticket_number = tic['ticket_number']
        ticket.status = 0

        ticket.save!
      end

      cnas.each do  |cna|
        cna.contract_id = @contract.id
        cna.contract!
        cna.save!
      end

      proposal.contract_id = @contract.id
      proposal.contract!
      proposal.save!
      
    end
    respond_with @contract, notice: 'Termo criado com sucesso.'
  end



  def delete_contract
    contract = params[:contract]

    contract = Contract.find(contract)
    cnas     = Cna.where('contract_id = ?', contract)
    tickets  = Ticket.where('contract_id = ?', contract)

    tickets.each  do |ticket|
      unless ticket.canceled? || ticket.generating? || ticket.status.nil?
        flash[:alert] = "Existem boletos emitidos. Termo não pode ser CANCELADO."
        redirect_to contract_path(contract) and return
      end
    end

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
    unit = Unit.find(current_user.unit_id)
    contract = Contract.find(params[:cod])
    tickets = Ticket.list(current_user.unit_id).where("contract_id = ?", params[:cod]).order('due')
    cnas = Cna.list(current_user.unit_id, session[:client_id]).where("contract_id = ?", params[:cod]).order('year')

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
    unit = Unit.find(current_user.unit_id)
    contract = Contract.find(params[:cod])
    tickets = Ticket.list(current_user.unit_id).where("contract_id = ?", params[:cod]).order('due')
    cnas = Cna.list(current_user.unit_id, session[:client_id]).where("contract_id = ?", params[:cod]).order('year')

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
    @ticket = Ticket.where('contract_id = ?', params[:cod]).order('due ASC')
    @keys = [:name, :url]
    @values = []

    @ticket.each do |ticket|
      if ticket.bank_billet_id.blank? || ticket.bank_billet_id.nil?
        @contract = Contract.find(ticket.contract_id)
        @taxpayer = Taxpayer.find(@contract.taxpayer_id)
        client = Client.find(@taxpayer.client_id)
        bank_billet_account = BankBilletAccount.find(client.bank_billet_account_id)
        bank_billet_account_unit = BankBilletAccount.find_by(bank_billet_account: session[:unit_bank_billet_account])
        cna = Cna.select('year').where('contract_id = ?', ticket.contract_id)

        t = Taxpayer.new(:cnpj => @taxpayer.cnpj, :cpf => @taxpayer.cpf)
        
        unless t.cnpj.nil?
          if t.cnpj.valido?
            cnpj_cpf = @taxpayer.cnpj.to_s
          end
        end
        
        unless t.cpf.nil?
          if t.cpf.valido?
            cnpj_cpf = @taxpayer.cpf.to_s
          end
        end
  
        ActiveRecord::Base.transaction do
          bank_billet = BoletoSimples::BankBillet.create({
                            amount: ticket.amount,
                            description: 'Servicos prestados conforme contrato',
                            expire_at: ticket.due,
                            customer_address: @taxpayer.address,
                            customer_address_complement: @taxpayer.complement,
                            customer_city_name: @taxpayer.city.name,
                            customer_cnpj_cpf: cnpj_cpf,
                            customer_neighborhood: @taxpayer.neighborhood.nil? ? ' ' : @taxpayer.neighborhood,
                            customer_person_name: @taxpayer.name,
                            customer_person_type: 'individual',
                            customer_state: @taxpayer.city.state,
                            customer_zipcode: @taxpayer.zipcode,
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
        end
      else
        @contract = Contract.find(ticket.contract_id)
        @taxpayer = Taxpayer.find(@contract.taxpayer_id)
        bank_billet = BankBillet.find(ticket.bank_billet_id)
        @values << [bank_billet.customer_person_name << '_' << bank_billet.our_number, bank_billet.shorten_url] if bank_billet.status == 'opened'
      end
    end

    if @values.present?
      require "open-uri"
      require 'zip'
      
      zipfile_name = "tmp/boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip"

      if File.exist? zipfile_name
          logger.info zipfile_name.inspect
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
      else
        @values.each do |filename,url|
          image_url = URI.parse(url)
          logger.info image_url.inspect
          file = Tempfile.new
          file.binmode
          file.write open(image_url).read

          Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
            zipfile.add(filename + '.pdf', file)
          end
          
          file.close!
        end
        send_file zipfile_name, filename: "boletos_do_contribuinte_" + @taxpayer.origin_code.to_s + ".zip", :type=>"application/zip", :disposition => "attachment", :x_sendfile=>true 
      end
    end
  end


  def report_payment_filter
    @months = [['Janeiro',1],['Fevereiro',2],['Março',3],['Abril',4],['Maio',5],['Junho',6],['Julho',7],['Agosto',8],['Setembro',9],['Outubro',10],['Novembro',11],['Dezembro',12]]
    @years = [[2016,'2016'],[2017,'2017']]
  end

  def report_payment_action
    @params_pdf = [params[:paid_ini_at], params[:paid_end_at], params[:type]]
    @rels = Ticket.find_by_sql ['select tax.name tname, tax.origin_code, cities.name cname, tax.cpf, t.paid_amount, t.paid_at, t.due, t.ticket_type, c.description, c.client_ticket_quantity, t.ticket_number, users.name from contracts c, tickets t, taxpayers tax, cities, users where c.user_id = users.id AND c.unit_id = ? AND paid_amount > ? and paid_at between ? and ? and c.id = t.contract_id and c.taxpayer_id = tax.id AND tax.city_id = cities.id AND t.ticket_type = ? AND c.client_id = ? order by tname, t.paid_at ASC', current_user.unit_id, 0, params[:paid_ini_at].to_date, params[:paid_end_at].to_date, params[:type], session[:client_id]]
  end

  def report_payment_action_pdf
    rels = Ticket.find_by_sql ['select  tax.name tname, 
                                        tax.origin_code, 
                                        cities.name cname, 
                                        tax.cpf, 
                                        t.paid_amount, 
                                        t.paid_at, 
                                        t.due, 
                                        t.ticket_type, 
                                        c.description, 
                                        c.client_ticket_quantity, 
                                        t.ticket_number, 
                                        users.name 
                                from    contracts c,
                                        tickets t,
                                        taxpayers tax, 
                                        cities, 
                                        users
                                where   c.user_id = users.id 
                                    AND c.unit_id = ? 
                                    AND paid_amount > ? 
                                    and paid_at between ? and ? 
                                    and c.id = t.contract_id 
                                    and c.taxpayer_id = tax.id 
                                    AND tax.city_id = cities.id 
                                    AND t.ticket_type = ? 
                                    AND c.client_id = ? 
                                order by tname, t.paid_at ASC', current_user.unit_id, 0, params[:cod][0].to_date, params[:cod][1].to_date, params[:cod][2], session[:client_id]]

    respond_to do |format|
      format.pdf do
      pdf = ReportPaymentPdf.new(rels, params[:cod], view_context)
      send_data pdf.render, filename: "Relatorio de Pagamentos",
                            type: "application/pdf",
                            disposition: "attachment"
      end
    end
  end

  def report_fee_filter
    @months = [['Janeiro',1],['Fevereiro',2],['Março',3],['Abril',4],['Maio',5],['Junho',6],['Julho',7],['Agosto',8],['Setembro',9],['Outubro',10],['Novembro',11],['Dezembro',12]]
    @years = [[2016,'2016'],[2017,'2017']]
  end

  def report_fee_action
    dt_ini = Date.new(params[:year].to_i, params[:month].to_i, 1)
    dt_fim = ((dt_ini + 1.month))
    @rels = Contract.find_by_sql(['select user_id, u.name, sum(paid_amount) paid_amount from contracts c, tickets t, users u where c.id = t.contract_id and c.user_id = u.id AND t.ticket_type = 1 and paid_amount > 0 AND t.status = 3  AND paid_at >= ? AND paid_at < ? group by user_id, u.name order by paid_amount DESC', dt_ini, dt_fim])
  end



  private
  def contract_params
    params.require(:contract).permit( :unit_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
