class ClientsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @clients = index_class(Client)
    respond_with @clients, :layout => 'application'
  end

  def show
    @client = Client.find(params[:id])
    respond_with @client
  end

  def new
    @client = Client.new
    respond_with @client
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(client_params)
    @client.unit_id = session[:unit_id]
    @client.save!
    respond_with @client
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @client
  end

  def update
    @client = Client.find(params[:id])
    @client.update_attributes(client_params)
    respond_with @client
  end


  def get_client
    @clients = Client.where("unit_id = ?", current_user.unit_id).select('id', 'name')
  end


  def set_client
    client = Client.find params[:client][:client_id]

    if client.present?
      session[:client_id] = client.id
      session[:client_name] = client.name
      redirect_to root_path
    end
  end



  private
    def client_params
      params.require(:client).permit( :name, :unit_id, :cnpj, :address, :zipcode, :email, :city, :state, :complement, :neighborhood, :bank_billet_account_id)
    end
end
