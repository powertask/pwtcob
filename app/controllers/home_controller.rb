 class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
    session[:unit_bank_billet_account] = 21
    session[:employee_id] = current_user.employee_id
    session[:taxpayer_id] = nil

    contracts_meter
  end

  def filter_name
    
    contracts_meter

    if params[:name].present?

      if params[:name].size < 3
        flash[:alert] = "Nome do contribuinte deve conter ao menos 3 letras."
        redirect_to :root and return
      end 

      if current_user.admin?
        @taxpayers = Taxpayer
                      .joins(:city)
                      .where("taxpayers.unit_id = ? AND lower(taxpayers.name) like ?", session[:unit_id], "%"<< params[:name].downcase << "%")
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      else
        @taxpayers = Taxpayer
                      .joins(:city)
                      .where("taxpayers.unit_id = ? AND cities.fl_charge = ? AND lower(taxpayers.name) like ? and employee_id = ?", session[:unit_id], true, "%"<< params[:name].downcase << "%", session[:employee_id])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      end


    elsif params[:cpf].present?

      unless params[:cpf].size == 14
        flash[:alert] = "CPF deve conter 11 números no formato 999.999.999-99"
        redirect_to :root and return
      end 

      if current_user.admin?
        @taxpayers = Taxpayer
                      .joins(:city)
                      .where("taxpayers.unit_id = ? AND taxpayers.cpf = ?", session[:unit_id], params[:cpf])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      else
        @taxpayers = Taxpayer
                      .joins(:city)
                      .where("taxpayers.unit_id = ? AND cities.fl_charge = ? AND taxpayers.cpf = ? and taxpayers.employee_id = ?", session[:unit_id], true, params[:cpf], session[:employee_id])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      end


    elsif params[:cna].present?

      if current_user.admin?
        @taxpayers = Taxpayer
                      .where("unit_id = ? AND origin_code = ?", session[:unit_id], params[:cna])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      else
        @taxpayers = Taxpayer
                      .joins(:city)
                      .where("taxpayers.unit_id = ? AND cities.fl_charge = ? AND taxpayers.origin_code = ? and taxpayers.employee_id = ?", session[:unit_id], true, params[:cna], session[:employee_id])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
      end
    end

    if @taxpayers.count == 0
      flash[:alert] = "Não encontrado contribuinte."
      redirect_to :root and return
    end 
  

    render "index", :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:cod])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order(:year)
    @histories = History.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order('created_at DESC')
    @contracts = Contract.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod])
    
    clear_variable_session()
    contracts_meter

    session[:taxpayer_id] = params[:cod]

    render "index", :layout => 'application'
  end


  def deal
    if current_user.client?
      flash[:alert] = "Não permitido acessar Ambiente de Negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @taxpayer = Taxpayer.find(params[:cod])

    unless Taxpayer.chargeble? @taxpayer
      flash[:alert] = "Cidade não liberada para negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @areas = Area.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order('year DESC, nr_document')


    @contract = Contract.new
    @contract.unit_ticket_quantity = 1
    @contract.client_ticket_quantity = 1

    @cnas = Cna.list(session[:unit_id]).not_pay.where('taxpayer_id = ?', params[:cod]).order(:year)
    @cna = Cna.new

    clear_variable_session()

    respond_with @taxpayer, :layout => 'application'     
  end

  def get_cna
    @cna = Cna.find(params[:cod])
  end

  
  def pay_cna
    if current_user.id == 1
      @cna = Cna.find(params[:cod])
      @cna.pay!

      redirect_to show_path(@cna.taxpayer_id) and return
    end
  end


  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)

    @cnas = Cna.list(session[:unit_id]).not_pay.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)

    clear_variable_session()

  end

  def get_tickets
    unit_ticket_quantity  =  params[:unit_ticket_quantity].to_i
    unit_ticket_due       =  params[:unit_ticket_due].to_date
    client_ticket_due     =  params[:client_ticket_due].to_date

    if unit_ticket_quantity == 1
      total_cna_a_vista = session[:total_cna_a_vista].to_f
      total_fee = session[:total_fee_a_vista].to_f.round(2)
      total_cna = total_cna_a_vista - total_fee      
    else
      total_cna_cobrado = session[:total_cna_cobrado].to_f
      total_fee = (session[:total_fee_cobrado].to_f).round(2)
      total_cna = total_cna_cobrado - total_fee      
    end

    cna_ticket = total_cna / unit_ticket_quantity.to_i
    @tickets = []

    unit_ticket_quantity  = unit_ticket_quantity + 1

    (1..unit_ticket_quantity).each  do |tic|
      
      unit_due = unit_ticket_due if tic == 1
      client_due = client_ticket_due if tic == 2
      client_due = client_ticket_due + (tic - 2).month if tic > 2

      ticket = { ticket: tic, unit_amount: total_fee, client_amount: 0.00, due: unit_due} if tic == 1
      ticket = { ticket: tic, unit_amount: 0.00, client_amount: cna_ticket.round(2), due: client_due} if tic > 1
      @tickets << ticket
      session[:tickets] = @tickets
    end
  end

  def get_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
  end

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
    @taxpayer.update_attributes(taxpayer_params)
  end

  private
  def cna_params
    params.require(:cna).permit(:fl_charge)
  end

  def taxpayer_params
    params.require(:taxpayer).permit(:phone)
  end

  def clear_variable_session

    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_correcao] = 0
    session[:total_cna] = 0

    session[:value_cna_cobrado] = 0
    session[:total_multa_cobrado] = 0
    session[:total_juros_cobrado] = 0
    session[:total_correcao_cobrado] = 0
    session[:total_cna_cobrado] = 0
    session[:total_cna_sem_fee_cobrado] = 0
    session[:total_fee_cobrado] = 0

    session[:value_cna_a_vista] = 0
    session[:total_multa_a_vista] = 0
    session[:total_juros_a_vista] = 0
    session[:total_correcao_a_vista] = 0
    session[:total_cna_a_vista] = 0
    session[:total_fee_a_vista] = 0

  end

  def contracts_meter 
    @count_contracts_day = Contract.list(session[:unit_id]).where('user_id = ? and contract_date between ? AND ?', current_user.id, Date.current.beginning_of_day, Date.current.end_of_day).count

    dt_ini = Date.new(Date.current.year, Date.current.month, 1).beginning_of_day
    dt_end = Date.current.end_of_day
    @count_contracts_month = Contract.list(session[:unit_id]).where('user_id = ? and contract_date between ? AND ?', current_user.id, dt_ini, dt_end ).count

    if current_user.admin?
      @count_contracts_day_master = Contract.where('contract_date between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
    else
      @count_contracts_day_master = Contract.where('user_id = ? AND contract_date between ? AND ?', current_user.id, Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
    end

    if current_user.admin?
      @count_contracts_month_master = Contract.where('contract_date between ? AND ?', dt_ini, dt_end).group('user_id').count
    else
      @count_contracts_month_master = Contract.where('user_id = ? AND contract_date between ? AND ?', current_user.id, dt_ini, dt_end).group('user_id').count
    end      

    @count_contracts_day_master = @count_contracts_day_master.map{|z|z}
    @count_contracts_month_master = @count_contracts_month_master.map{|z|z}

  end
end
