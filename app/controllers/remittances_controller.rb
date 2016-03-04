class RemittancesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    if current_user.client?
      @remittances = BoletoSimples::Remittance.where('bank_billet_account = ?', 47)(page: 1, per_page: 5)
    else
      @remittances = BoletoSimples::Remittance.all(page: 1, per_page: 5)

    end 
     
    respond_with @remittances, :layout => 'application'
  end

  def remittance_new
  end

  def remittance_create
    bank_billet_account = BankBilletAccount.find(params[:bank_billet_account])
    @remittance = BoletoSimples::Remittance.create(bank_billet_account_id: bank_billet_account.bank_billet_account)

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
