class ProposalTicketsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def edit
    @ticket = ProposalTicket.find(params[:id])

    proposal = Proposal.find @ticket.proposal_id

   if proposal.contract?
      flash[:alert] = "Ação não permitida. Proposta ja gerou um TERMO NRO " << proposal.contract_id.to_s
      redirect_to :proposals and return
    end     

  end

  def update
    @ticket = ProposalTicket.find(params[:id])
    @ticket.update_attributes(proposal_ticket_params)

    proposal = Proposal.find @ticket.proposal_id
    respond_with proposal
  end

  private
    def proposal_ticket_params
      params.require(:proposal_ticket).permit( :amount )
    end
end
