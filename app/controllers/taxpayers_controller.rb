class TaxpayersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @taxpayers = index_class(Taxpayer)
    respond_with @taxpayers, :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:id])
    respond_with @taxpayer
  end

  def new
    @taxpayer = Taxpayer.new
    respond_with @taxpayer
  end

  def edit
    @taxpayer = Taxpayer.find(params[:id])
  end

  def create
    @taxpayer = Taxpayer.new(taxpayer_params)
    @taxpayer.unit_id = session[:unit_id]
    @taxpayer.save!
    respond_with @taxpayer
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @taxpayer
  end

  def update
    @taxpayer = Taxpayer.find(params[:id])
    @taxpayer.update_attributes(taxpayer_params)
    respond_with @taxpayer
  end

  private
    def taxpayer_params
      params.require(:taxpayer).permit( :name, :unit_id, :cpf, :address, :zipcode, :email, :state, :complement, :phone, :neighborhood, :city, :client_id, :cnpj, :origin_code)
    end
end
