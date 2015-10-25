class ClientsController < ApplicationController
  before_filter :authenticate_user!
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

  private
    def client_params
      params.require(:client).permit( :name, :unit_id, :cnpj, :address, :zipcode, :email, :state, :complement, :neighborhood)
    end
end