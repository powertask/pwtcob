class BankBilletsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @bank_billets = BankBillet.where("unit_id = ?", session[:unit_id]).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
    respond_with @bank_billets, :layout => 'application'
  end

  def show
    @bank_billet = BankBillet.find(params[:id])
    respond_with @bank_billet
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

  private
    def bank_billet_params
      params.require(:bank_billet).permit(:unit_id, :bank_billet_account_id, :origin_code, :our_number, :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :status, :paid_at, :paid_amount, :shorten_url, :fine_for_delay, :late_payment_interest, :document_date, :document_amount)
    end

end
