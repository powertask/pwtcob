class TicketsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def create_new_expire_at
    ticket = Ticket.find(params[:cod])

    @contract = Contract.find ticket.contract_id
    
    @ticket = Ticket.new
    @ticket.unit_id = ticket.unit_id
    @ticket.contract_id = ticket.contract_id
    @ticket.ticket_type = ticket.ticket_type
    @ticket.amount = ticket.amount
    @ticket.ticket_number = ticket.ticket_number
    @ticket.status = :generating

    respond_with @ticket
  end

  def update_status_ticket
    @ticket = Ticket.find(params[:cod])
    @contract = Contract.find @ticket.contract_id

    respond_with @ticket
  end

  def create
    @ticket = Ticket.new(ticket_params)

    @ticket.save!
    respond_with @ticket
  end

  def show
    redirect_to( contracts_path)
  end

  def update
    ticket = Ticket.find(params[:id])
    billet = BankBillet.find ticket.bank_billet_id

    bank_billet = BoletoSimples::BankBillet.find(ticket.bank_billet.origin_code)

    if bank_billet.cancel
      ActiveRecord::Base.transaction do
        ticket.paid_at = ticket.due
        ticket.paid_amount = ticket.amount
        ticket.status = :paid
        ticket.save!

        billet.paid_at = ticket.due
        billet.paid_amount = ticket.amount
        billet.status = :paid
        billet.save!
      end

      flash[:alert] = "Boleto PAGO MANUALMENTE. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
    else
      flash[:alert] = "Não foi possível PAGAR manualmente boleto. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
    end


    respond_with @ticket
  end

  private
    def ticket_params
      params.require(:ticket).permit(:due, :unit_id, :ticket_number, :ticket_type, :amount, :contract_id, :status, :paid_at, :paid_amount)
    end
end
