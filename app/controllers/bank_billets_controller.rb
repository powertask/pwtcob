class BankBilletsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html

  layout 'window'

  def index

    name = ''
    filter_status = 'todos status...'

    if params[:filter].present?
      if params[:filter][:name].present?
        name = params[:filter][:name].upcase
      end

      if params[:filter][:status].present?
        filter_status = params[:filter][:status].downcase
      end
    end


    if filter_status == 'todos status...'
      
      if current_user.client?
        @bank_billets = BankBillet
                        .joins(:tickets)
                        .where("bank_billets.unit_id = ? AND tickets.client_id = ? AND bank_billets.bank_billet_account_id = ?", current_user.unit_id, session[:client_id], 2)
                        .order('expire_at DESC')
                        .paginate(:page => params[:page], :per_page => 20)
      
      elsif current_user.user?
        @bank_billets = BankBillet.paginate_by_sql(['select bank_billets.* from contracts, tickets, bank_billets where contracts.id = tickets.contract_id and tickets.bank_billet_id = bank_billets.id and contracts.user_id = ? AND tickets.client_id = ? AND customer_person_name like ?', current_user.id, session[:client_id], "%"<< name << "%"], :page => params[:page], :per_page => 20)
      
      elsif current_user.admin?
        @bank_billets = BankBillet
                        .joins(:tickets)
                        .where("bank_billets.unit_id = ? AND tickets.client_id = ? AND bank_billets.customer_person_name like ?", current_user.unit_id, session[:client_id], "%"<< name << "%")
                        .order('expire_at DESC')
                        .paginate(:page => params[:page], :per_page => 20)
        status_counter
      end

    else
      status = 0 if filter_status == 'gerando'
      status = 1 if filter_status == 'aberto'
      status = 2 if filter_status == 'cancelado'
      status = 3 if filter_status == 'pago'
      status = 4 if filter_status == 'vencido'
      status = 5 if filter_status == 'bloqueado'
      status = 6 if filter_status == 'devolucao'

      if current_user.client?
        @bank_billets = BankBillet.joins(:tickets).where("unit_id = ? AND bank_billet_account_id = ? AND status = ?", current_user.unit_id, 2, status).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
      
      elsif current_user.user?
        @bank_billets = BankBillet.paginate_by_sql(['select bank_billets.* from contracts, tickets, bank_billets where contracts.id = tickets.contract_id and tickets.bank_billet_id = bank_billets.id and contracts.user_id = ? AND tickets.client_id = ? AND tickets.status = ? AND customer_person_name like ? ', current_user.id, session[:client_id], status, "%"<< name << "%"], :page => params[:page], :per_page => 20)
      
      elsif current_user.admin?
        @bank_billets = BankBillet.joins(:tickets).where("bank_billets.unit_id = ? AND tickets.client_id = ? AND bank_billets.status = ? AND customer_person_name like ?", current_user.unit_id, session[:client_id], status, "%"<< name << "%").order('bank_billets.expire_at DESC').paginate(:page => params[:page], :per_page => 20)
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
    ticket = Ticket.find params[:cod]

    if ticket.present?
      
      bank_billet = BoletoSimples::BankBillet.find(ticket.bank_billet.origin_code)

      if bank_billet.cancel
        ticket.canceled!
        ticket.bank_billet.canceled!
        
        flash[:alert] = "Boleto CANCELADO. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
      else
        flash[:alert] = "Não foi possível CANCELAR boleto. Numero: " << bank_billet.our_number.to_s << ' Contribuinte: ' << bank_billet.customer_person_name
      end
    else
      flash[:alert] = "Parcela não encontrada."      
    end
    respond_with contract_path(ticket.contract_id)
  end


  private
    def bank_billet_params
      params.require(:bank_billet).permit(:unit_id, :bank_billet_account_id, :origin_code, :our_number, :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :status, :paid_at, :paid_amount, :shorten_url, :fine_for_delay, :late_payment_interest, :document_date, :document_amount)
    end

    def status_counter 
      @count_open = BankBillet.joins(:tickets).opened.where("bank_billets.unit_id = ? AND tickets.client_id = ?", current_user.unit_id, session[:client_id]).count
      @count_overdue = BankBillet.joins(:tickets).overdue.where("bank_billets.unit_id = ? AND tickets.client_id = ?", current_user.unit_id, session[:client_id]).count
      @count_paid = BankBillet.joins(:tickets).paid.where("bank_billets.unit_id = ? AND tickets.client_id = ?", current_user.unit_id, session[:client_id]).count
      @count_canceled = BankBillet.joins(:tickets).canceled.where("bank_billets.unit_id = ? AND tickets.client_id = ?", current_user.unit_id, session[:client_id]).count
      @count_generating = BankBillet.joins(:tickets).generating.where("bank_billets.unit_id = ? AND tickets.client_id = ?", current_user.unit_id, session[:client_id]).count
    end

end
