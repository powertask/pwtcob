class RemittancesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @remittances = BoletoSimples::Remittance.all(page: 1, per_page: 5)
    respond_with @remittances, :layout => 'application'
  end

  def remittance_create
  	@remittance = BoletoSimples::Remittance.create(bank_billet_account_id: 21)

  	if @remittance.persisted?
  	  puts "Sucesso :)"
  	  puts @remittance.attributes
  	else
  	  puts "Erro :("
  	  puts @remittance.response_errors
  	end
  end

  def remittance_download
  	remittance = BoletoSimples::Remittance.find(params[:cod])
  	redirect_to remittance.url
  end

end
