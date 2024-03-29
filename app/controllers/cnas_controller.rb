class CnasController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @cnas = Cna.where("unit_id = ?", current_user.unit_id).paginate(:page => params[:page], :per_page => 20)
    respond_with @cnas, :layout => 'application'
  end

  def show
    @cna = Cna.find(params[:id])
    respond_with @cna
  end

  def new
    @cna = Cna.new
    @cna.unit_id = current_user.unit_id
    @cna.client_id = session[:client_id]
    @cna.taxpayer_id = params[:format]
  end

  def edit
    @cna = Cna.find(params[:id])
  end

  def create
    @cna = Cna.new(cna_params)
    @cna.unit_id = current_user.unit_id
    @cna.client_id = session[:client_id]
    @cna.stage = 1
    @cna.status = 0
    @cna.fl_charge = 0
    @cna.start_at = Date.current
    @cna.due_at = Date.new(@cna.year, 5, 22)
    @cna.save!

    @taxpayer = Taxpayer.find(@cna.taxpayer_id)
    respond_with @taxpayer
  end

  def update
    @cna = Cna.find(params[:id])
    @cna.update_attributes(cna_params)
    redirect_to( taxpayer_path(@cna.taxpayer.id))
  end

  def report_cna_lawyer_filter
  end

  def report_cna_lawyer_rel
    if params[:report][:user_id].empty?
      @rels = Cna.lawyer.where('unit_id = ? and client_id = ?', current_user.unit_id, session[:client_id])
    else
      @rels = Cna.joins(:taxpayer).lawyer.where('cnas.unit_id = ? and cnas.client_id = ? and taxpayers.user_id = ?', current_user.unit_id, session[:client_id], params[:report][:user_id])
    end 
  end


  private
    def cna_params
      params.require(:cna).permit(:fl_charge, :amount, :status, :stage, :nr_document, :taxpayer_id, :unit_id, :year, :client_id)
    end
end
