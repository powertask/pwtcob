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
    @total_cna = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:cod]).sum(:amount)

    session[:cnas] = @cnas

    respond_with @taxpayer, :layout => 'application'     
  end

  def get_cna
    @cna = Cna.find(params[:cod])
  end

  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', @cna.taxpayer.id)

  end

  private
  def cna_params
    params.require(:cna).permit(:fl_charge)
  end

end
