class LawyersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @lawyers = index_class(Lawyer)
    respond_with @lawyers, :layout => 'application'
  end

  def show
    @lawyer = Lawyer.find(params[:id])
    respond_with @lawyer
  end

  def new
    @lawyer = Lawyer.new
    respond_with @lawyer
  end

  def edit
    @lawyer = Lawyer.find(params[:id])
  end

  def create
    @lawyer = Lawyer.new(lawyer_params)
    @lawyer.unit_id = session[:unit_id]
    @lawyer.save!
    respond_with @lawyer
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @lawyer
  end

  def update
    @lawyer = Lawyer.find(params[:id])
    @lawyer.update_attributes(lawyer_params)
    respond_with @lawyer
  end

  def destroy
    @lawyer.destroy
    respond_to do |format|
      format.html { redirect_to lawyers_url, notice: 'Lawyer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def lawyer_params
      params.require(:lawyer).permit(:name, :lawyer_code, :cpf, :cnpj, :phone, :zipcode, :address, :state, :city, :complement, :neighborhood, :email, :unit_id)
    end
end
