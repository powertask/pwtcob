class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  layout 'application'
require 'pry'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
  end

  def filter_name
    @taxpayers = Taxpayer
                    .where("unit_id = ? AND lower(name) like ?", session[:unit_id], params[:name].downcase << "%")
                    .paginate(:page => params[:page], :per_page => 10)
                    .order('name ASC')
    render "index", :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:id])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:id])
    
    @total_cna = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:id]).sum(:amount)
    session[:total_cnas] = @total_cnas

    @histories = History.list(session[:unit_id]).where('taxpayer_id = ?', params[:id])

    render "index", :layout => 'application'
  end

  def deal
    @contract = Contract.new
    @contract.unit_ticket_quantity = 1
    @contract.client_ticket_quantity = 1

    @taxpayer = Taxpayer.find(params[:cod])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).order(:year)
    @cna = Cna.new

    session[:total_cnas] = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).sum(:amount)

    @total_charge = Cna.list(session[:unit_id]).where('taxpayer_id = ? AND fl_charge = ?', params[:cod], true).sum(:amount)
    session[:total_charge] = @total_charge

    respond_with @taxpayer, :layout => 'application'     
  end

  def get_cna
    @cna = Cna.find(params[:cod])
  end

  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)

    @cnas         = Cna.list(session[:unit_id]).where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)

    @total_charge = Cna.list(session[:unit_id]).where('taxpayer_id = ? AND fl_charge = ?', @cna.taxpayer.id, true).sum(:amount)
    session[:total_charge] = @total_charge
  end

  def get_tickets
    unit_perc             =  params[:unit_perc].to_d
    unit_ticket_quantity  =  params[:unit_ticket_quantity].to_i
    unit_ticket_due       =  params[:unit_ticket_due].to_date

    total_charge = session[:total_charge]

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
    end
  end


  private
  def cna_params
    params.require(:cna).permit(:fl_charge)
  end

end
