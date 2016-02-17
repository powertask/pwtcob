class BankBilletsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)

    @bankbillets = billets
    respond_with @bankbillets, :layout => 'application'
  end

  def bank_billet_show
  	@bank_billet = BoletoSimples::BankBillet.find(params[:cod])
  	respond_with @bank_billet
  end

  def bank_billet_cancel
    bank_billet = BoletoSimples::BankBillet.find(params[:cod])

    if bank_billet.cancel
      @response_errors = "Cancelado!"
    else
      @response_errors = bank_billet.response_errors
    end
  end

end
