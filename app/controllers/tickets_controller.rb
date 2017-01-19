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

  def create

    require 'pry';
    binding.pry;
    @ticket = Ticket.new(ticket_params)

    @ticket.save!
    respond_with @ticket
  end

  def show
    redirect_to( contracts_path)
  end

  private
    def ticket_params
      params.require(:ticket).permit(:due, :unit_id, :ticket_number, :ticket_type, :amount, :contract_id, :status)
    end
end
