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
                    .where('taxpayers.unit_id = ? AND employee_id = ? AND cities.fl_charge = ?', session[:unit_id], session[:employee_id], true) 
                    .paginate(:page => params[:page], :per_page => 20)
                    .order('name ASC')
    else
      @taxpayers = index_class(Taxpayer)
      @taxpayers = @taxpayers
                    .joins(:city)
                    .where('taxpayers.unit_id = ?', session[:unit_id]) 
                    .paginate(:page => params[:page], :per_page => 20)
                    .order('name ASC')
    end      
    respond_with @taxpayers, :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:id])
    @taxpayer_contacts = TaxpayerContact.where('taxpayer_id = ?', @taxpayer.id)
    @cnas = Cna.where('taxpayer_id = ?', @taxpayer.id).order('year ASC')

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
      params.require(:taxpayer).permit( :name, :unit_id, :cpf, :address, :zipcode, :email, :complement, :phone, :neighborhood, :city_id, :client_id, :cnpj, :origin_code, :employee_id)
    end
end
