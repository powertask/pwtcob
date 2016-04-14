class BankBilletsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index

    if params[:status].nil? or params[:status].downcase == 'todos'
      if current_user.client?
        @bank_billets = BankBillet.where("unit_id = ? AND bank_billet_account_id = ?", session[:unit_id], 2).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
      elsif current_user.user?
        @bank_billets = BankBillet.paginate_by_sql(['select b.* from contracts c, tickets t, bank_billets b where c.id = t.contract_id and t.bank_billet_id = b.id and c.user_id = ?', current_user.id], :page => params[:page], :per_page => 20)
      elsif current_user.admin?
        @bank_billets = BankBillet.where("unit_id = ?", session[:unit_id]).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
        status_counter
      end

    else
      status = 0 if params[:status].downcase == 'gerando'
      status = 1 if params[:status].downcase == 'aberto'
      status = 2 if params[:status].downcase == 'cancelado'
      status = 3 if params[:status].downcase == 'pago'
      status = 4 if params[:status].downcase == 'vencido'
      status = 5 if params[:status].downcase == 'bloqueado'
      status = 6 if params[:status].downcase == 'devolucao'

      if current_user.client?
        @bank_billets = BankBillet.where("unit_id = ? AND bank_billet_account_id = ? AND status = ?", session[:unit_id], 2, status).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
      elsif current_user.user?
        @bank_billets = BankBillet.paginate_by_sql(['select b.* from contracts c, tickets t, bank_billets b where c.id = t.contract_id and t.bank_billet_id = b.id and c.user_id = ? AND t.status = ?', current_user.id, status], :page => params[:page], :per_page => 20)
      elsif current_user.admin?
        @bank_billets = BankBillet.where("unit_id = ? AND status = ?", session[:unit_id], status).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
        status_counter
      end     
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
      flash[:alert] = "Boleto CANCELADO. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
    else
      flash[:alert] = "Não foi possível CANCELAR boleto. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
    end
    respond_with @bank_billet
  end


  private
    def bank_billet_params
      params.require(:bank_billet).permit(:unit_id, :bank_billet_account_id, :origin_code, :our_number, :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :status, :paid_at, :paid_amount, :shorten_url, :fine_for_delay, :late_payment_interest, :document_date, :document_amount)
    end

    def status_counter 
      @count_open = BankBillet.opened.where("unit_id = ?", session[:unit_id]).count
      @count_overdue = BankBillet.overdue.where("unit_id = ?", session[:unit_id]).count
      @count_paid = BankBillet.paid.where("unit_id = ?", session[:unit_id]).count
    end

end
