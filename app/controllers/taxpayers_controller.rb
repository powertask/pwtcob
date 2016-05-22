class TaxpayersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    if current_user.user?
      @taxpayers = index_class(Taxpayer)
      @taxpayers = @taxpayers
                    .joins(:city)
                    .where('taxpayers.unit_id = ? AND user_id = ? AND taxpayers.client_id = ? AND cities.fl_charge = ?', session[:unit_id], session[:client_id], current_user.id, true) 
                    .paginate(:page => params[:page], :per_page => 20)
                    .order('name ASC')
    else
      @taxpayers = index_class(Taxpayer)
      @taxpayers = @taxpayers
                    .joins(:city)
                    .where('taxpayers.unit_id = ? AND taxpayers.client_id = ?', session[:unit_id], session[:client_id]) 
                    .paginate(:page => params[:page], :per_page => 20)
                    .order('name ASC')
    end      
    respond_with @taxpayers, :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.where('id = ? AND unit_id = ?, client_id ?', params[:id], session[:unit_id], session[:client_id]).first
    @taxpayer_contacts = TaxpayerContact.where('taxpayer_id = ?', @taxpayer.id)
    @cnas = Cna.where('taxpayer_id = ?', @taxpayer.id).order('year ASC')

    respond_with @taxpayer
  end

  def new
    @taxpayer = Taxpayer.new
    respond_with @taxpayer
  end

  def edit
    @taxpayer = Taxpayer.where('id = ? AND unit_id = ?, client_id ?', params[:id], session[:unit_id], session[:client_id]).first
  end

  def create
    @taxpayer = Taxpayer.new(taxpayer_params)
    @taxpayer.unit_id = session[:unit_id]
    @taxpayer.client_id = session[:client_id]
    @taxpayer.save!
    respond_with @taxpayer
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @taxpayer
  end

  def update
    @taxpayer = Taxpayer.where('id = ? AND unit_id = ?, client_id ?', params[:id], session[:unit_id], session[:client_id]).first
    @taxpayer.update_attributes(taxpayer_params)
    respond_with @taxpayer
  end

  private
    def taxpayer_params
      params.require(:taxpayer).permit( :name, :unit_id, :client_id, :user_id, :cpf, :address, :zipcode, :email, :complement, :phone, :neighborhood, :city_id, :client_id, :cnpj, :origin_code)
    end
end
