class BankBilletsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    if current_user.client?
      @bank_billets = BankBillet.where("unit_id = ? AND bank_billet_account_id = ?", session[:unit_id], 2).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
    elsif current_user.user?
      @bank_billets = BankBillet.paginate_by_sql(['select b.* from contracts c, tickets t, bank_billets b where c.id = t.contract_id and t.bank_billet_id = b.id and c.employee_id = ?', current_user.employee_id], :page => params[:page], :per_page => 20)
    elsif current_user.admin?
      @bank_billets = BankBillet.where("unit_id = ?", session[:unit_id]).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
    end

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
