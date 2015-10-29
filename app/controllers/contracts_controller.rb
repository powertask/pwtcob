class ContractsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'


  def deal
  	@taxpayer = Taxpayer.find(params[:cod])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod])
    respond_with @taxpayer, :layout => 'application'     
  end

  private
  def contract_params
    params.require(:contract).permit( :unit_id )
  end

end
