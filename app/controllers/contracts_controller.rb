class ContractsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  
  def create
    @contract = Contract.new(contract_params)
    session[:unit_ticket_quantity] = :unit_ticket_quantity
    session[:client_ticket_quantity] = :client_ticket_quantity
  end


  private
  def contract_params
    params.require(:contract).permit( :unit_id, :unit_ticket_quantity, :client_ticket_quantity )
  end

end
