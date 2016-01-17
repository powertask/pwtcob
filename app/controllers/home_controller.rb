 class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
  end

  def filter_name
    if params[:name].present?

      if params[:name].size <= 2
        flash[:alert] = "Nome do contribuinte deve conter ao menos 3 letras."
        redirect_to :root and return
      end 

      @taxpayers = Taxpayer
                      .where("unit_id = ? AND lower(name) like ?", session[:unit_id], "%"<< params[:name].downcase << "%")
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')

      if @taxpayers.count == 0
        flash[:alert] = "Não encontrado contribuinte."
        redirect_to :root and return
      end 
    
    elsif params[:cpf].present?
      @taxpayers = Taxpayer
                      .where("unit_id = ? AND cpf = ?", session[:unit_id], params[:cpf])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')

    elsif params[:cna].present?
      @taxpayers = Taxpayer
                      .where("unit_id = ? AND origin_code = ?", session[:unit_id], params[:cna])
                      .paginate(:page => params[:page], :per_page => 10)
                      .order('name ASC')
    end

    render "index", :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:cod])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order(:year)
    @histories = History.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod])
    @contracts = Contract.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod])
    @areas = Area.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order('year DESC, nr_document')
    
    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_cna] = 0

    render "index", :layout => 'application'
  end


  def deal
    @taxpayer = Taxpayer.find(params[:cod])

    if @taxpayer.city.present?
      if @taxpayer.city.fl_charge == false
        flash[:notice] = "Colaborador de uma cidade não liberada para cobrança!"
        redirect_to :root and return 
      end
    else
      flash[:notice] = "Colaborador de uma cidade não liberada para cobrança!"
      redirect_to :root and return
    end

    @contract = Contract.new
    @contract.unit_ticket_quantity = 1
    @contract.client_ticket_quantity = 1

    @cnas = Cna.list(session[:unit_id]).not_pay.where('taxpayer_id = ?', params[:cod]).order(:year)
    @cna = Cna.new

    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_cna] = 0
    session[:total_cobrado]  = 0

    respond_with @taxpayer, :layout => 'application'     
  end

  def get_cna
    @cna = Cna.find(params[:cod])
  end

  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)

    @cnas = Cna.list(session[:unit_id]).not_pay.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)

    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_cobrado] = 0
    session[:total_cna] = 0
  end

  def get_tickets
    unit = Unit.find(session[:unit_id])
    unit_perc =  unit.unit_fee

    unit_ticket_quantity  =  params[:unit_ticket_quantity].to_i
    unit_ticket_due       =  params[:unit_ticket_due].to_date

    unit_perc = 0 if unit_perc.nil?

    total_charge = session[:total_cobrado]

    unit_amount = total_charge * unit_perc / 100
    unit_amount = unit_amount.round(2)

    cna_ticket = total_charge / unit_ticket_quantity.to_i
    @tickets = []

    unit_ticket_quantity  = unit_ticket_quantity + 1

    (1..unit_ticket_quantity).each  do |tic|
      
      unit_due = unit_ticket_due if tic == 1
      unit_due = unit_ticket_due + (tic - 1).month if tic > 1

      ticket = { ticket: tic, unit_amount: unit_amount, client_amount: 0.00, due: unit_due} if tic == 1
      ticket = { ticket: tic, unit_amount: 0.00, client_amount: cna_ticket.round(2), due: unit_due} if tic > 1
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

end
