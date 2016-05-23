class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    if current_user.admin? || current_user.client?
      @proposals = Proposal.where("unit_id = ?", session[:unit_id]).paginate(:page => params[:page], :per_page => 20)
    else
      @proposals = Proposal.where("unit_id = ? AND user_id = ?", session[:unit_id], current_user.id).paginate(:page => params[:page], :per_page => 20)
    end
    respond_with @proposals, :layout => 'application'
  end

  def show
    @proposal = Proposal.find(params[:id])
    @tickets = ProposalTicket.list(params[:id]).order('ticket_number')
    respond_with @proposal
  end

  def create_proposal
    cod = params[:cod]

    taxpayer = Taxpayer.find(cod)
    cnas = Cna.list(session[:unit_id], session[:client_id]).not_pay.where('taxpayer_id = ? and fl_charge = ?', cod, true)
    unit = Unit.find(session[:unit_id])

    ActiveRecord::Base.transaction do
      @proposal = Proposal.new

      @proposal.unit_id = session[:unit_id]
      @proposal.user_id = current_user.id
      @proposal.taxpayer_id = cod
      
      if session[:tickets].count == 2
        unit_amount = session[:total_fee_a_vista].to_f
        @proposal.unit_amount = unit_amount.round(2)

        client_amount = session[:total_cna_a_vista].to_f - session[:total_fee_a_vista].to_f
        @proposal.client_amount = client_amount.round(2)
        
        @proposal.client_ticket_quantity = 1

      else
        unit_amount = session[:total_fee_cobrado].to_f
        @proposal.unit_amount = unit_amount.round(2)

        client_amount = session[:total_cna_cobrado].to_f - session[:total_fee_cobrado].to_f
        @proposal.client_amount = client_amount.round(2)
        
        @proposal.client_ticket_quantity = session[:tickets].count - 1
      end
      
      @proposal.unit_ticket_quantity = 1
      @proposal.unit_fee = 10
      @proposal.status = 0

      @proposal.save!

      n = 0
      session[:tickets].each  do |tic|
        n = n + 1
        @ticket = ProposalTicket.new
        @ticket.unit_id = session[:unit_id]
        @ticket.proposal_id = @proposal.id
        @ticket.ticket_type = 0 if tic['unit_amount'].to_f == 0
        @ticket.ticket_type = 1 if tic['unit_amount'].to_f > 0
        
        @ticket.amount = tic['client_amount'].to_f if tic['client_amount'].to_f > 0
        @ticket.amount = tic['unit_amount'].to_f if tic['unit_amount'].to_f > 0
        
        @ticket.due_at = tic['due'].to_date
        @ticket.ticket_number = n

        @ticket.save!
      end

      cnas.each do  |cna|
        cna.proposal_id = @proposal.id
        cna.proposal!
        cna.save!
      end
    end

    respond_with @proposal, notice: 'Proposta criada com sucesso.'

  end


  private
  def proposal_params
    params.require(:proposal).permit(:unit_id, :user_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
