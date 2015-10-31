class CnasController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @cnas = index_class(Cna)
    respond_with @cnas, :layout => 'application'
  end

  def show
    @cna = Cna.find(params[:id])
    respond_with @cna
  end

  def new
    @cna = Cna.new
    respond_with @cna
  end

  def edit
    @cna = Cna.find(params[:id])
    taxpayer = @cna.taxpayer.id
    @taxpayer = Taxpayer.find(taxpayer)
  end

  def create
    @cna = Cna.new(cna_params)
    @cna.unit_id = session[:unit_id]
    @cna.save!
    respond_with @cna
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @cna
  end

  def update
    @cna = Cna.find(params[:id])
    @cna.update_attributes(cna_params)
    redirect_to( deal_url(cod: @cna.taxpayer.id))
  end

  private
    def cna_params
      params.require(:cna).permit(:fl_charge, :amount, :status, :stage)
    end
end
