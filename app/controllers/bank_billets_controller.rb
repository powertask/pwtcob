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

end
