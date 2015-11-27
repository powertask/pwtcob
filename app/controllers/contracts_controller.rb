class ContractsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @contracts = index_class(Contract, {order: false})
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

    unit_fee =  unit.unit_fee
    unit_fee = 0 if unit_fee.nil?

    total_charge = session[:total_cobrado]

    unit_amount = total_charge * unit_fee / 100
    unit_amount = unit_amount.round(2)

    ActiveRecord::Base.transaction do
      @contract = Contract.new

      @contract.unit_id = session[:unit_id]
      @contract.contract_date = Time.now
      @contract.taxpayer_id = cod 
      @contract.unit_amount = unit_amount
      @contract.unit_fee = unit_fee
      @contract.unit_ticket_quantity = 1

      @contract.client_ticket_quantity = session[:tickets].count - 1
      @contract.client_amount = total_charge

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

    respond_with @contract, notice: 'Contrato criado com sucesso.'

  end

  def contract_pdf
    unit = Unit.find(session[:unit_id])
    contract = Contract.find(params[:cod])
    tickets = Ticket.list(session[:unit_id]).where("contract_id = ?", params[:cod])
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

  private
  def contract_params
    params.require(:contract).permit( :unit_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
