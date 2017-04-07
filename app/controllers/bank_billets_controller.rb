class BankBilletsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html

  layout 'window'

  def index

    name = ''
    name = params[:name].upcase unless params[:name].nil?

    filter_dates = ''

    if params[:due_at].present?
      filter_dates << ' AND expire_at = ?'
    else
      filter_dates << ' AND expire_at > ?'
      params[:due_at] = '01/01/2000'.to_date
    end

    if params[:paid_at].present?
      filter_dates << ' AND bank_billets.paid_at = ?'
    else
      filter_dates << ' AND bank_billets.paid_at > ?'
      params[:paid_at] = '01/01/2000'.to_date
    end



    if params[:status].nil? or params[:status].downcase == 'todos status...'
      
      if current_user.client?
        @bank_billets = BankBillet.joins(:tickets).where("bank_billets.unit_id = ? AND tickets.client_id = ? AND bank_billets.bank_billet_account_id = ?", current_user.unit_id, session[:client_id], 2).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
      
      elsif current_user.user?
        @bank_billets = BankBillet.paginate_by_sql(['select bank_billets.* from contracts, tickets, bank_billets where contracts.id = tickets.contract_id and tickets.bank_billet_id = bank_billets.id and contracts.user_id = ? AND tickets.client_id = ? AND customer_person_name like ? ' + filter_dates, current_user.id, session[:client_id], "%"<< name << "%", params[:due_at].to_date, params[:paid_at].to_date], :page => params[:page], :per_page => 20)
      
      elsif current_user.admin?
        @bank_billets = BankBillet.joins(:tickets).where("bank_billets.unit_id = ? AND tickets.client_id = ? AND bank_billets.customer_person_name like ? " + filter_dates, current_user.unit_id, session[:client_id], "%"<< name << "%", params[:due_at].to_date, params[:paid_at].to_date).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
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
        @bank_billets = BankBillet.joins(:tickets).where("unit_id = ? AND bank_billet_account_id = ? AND status = ?", current_user.unit_id, 2, status).order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
      
      elsif current_user.user?
#        @bank_billets = BankBillet.paginate_by_sql(['select bank_billets.* from contracts, tickets, bank_billets where contracts.id = tickets.contract_id and tickets.bank_billet_id = bank_billets.id and contracts.user_id = ? AND tickets.client_id = ? AND customer_person_name like ? ' + filter_dates, current_user.id, session[:client_id], "%"<< name << "%", params[:due_at].to_date, params[:paid_at].to_date], :page => params[:page], :per_page => 20)
        @bank_billets = BankBillet.paginate_by_sql(['select bank_billets.* from contracts, tickets, bank_billets where contracts.id = tickets.contract_id and tickets.bank_billet_id = bank_billets.id and contracts.user_id = ? AND tickets.client_id = ? AND tickets.status = ? AND customer_person_name like ? ' + filter_dates, current_user.id, session[:client_id], status, "%"<< name << "%", params[:due_at].to_date, params[:paid_at].to_date], :page => params[:page], :per_page => 20)
      
      elsif current_user.admin?
        @bank_billets = BankBillet.joins(:tickets).where("bank_billets.unit_id = ? AND client_id = ? AND status = ? AND customer_person_name like ?", current_user.unit_id, session[:client_id], status, "%"<< name << "%").order('expire_at DESC').paginate(:page => params[:page], :per_page => 20)
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
    end

end
