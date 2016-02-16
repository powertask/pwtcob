class DischargesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @discharges = BoletoSimples::Discharge.all(page: 1, per_page: 10)
    respond_with @discharges, :layout => 'application'
  end

  def sent_discharge
  end

  def create_discharge
  	@discharge = BoletoSimples::Discharge.create(filename: params[:attached], content: 'multipart/form-data')

  	if @discharge.persisted?
  	  puts "Sucesso :)"
  	  puts @discharge.attributes
  	else
  	  puts "Erro :("
  	  puts @discharge.response_errors
  	end  	
  end
end
