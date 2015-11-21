class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  # GET /cities
  # GET /cities.json
  def index
    @cities = index_class(City)
    respond_with @cities, :layout => 'application'
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
    @city.unit_id = session[:unit_id]
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)
    @city.save
    respond_with @city, notice: 'Cidade criada com sucesso.'
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    @city.update_attributes(city_params)
    respond_with @city, notice: 'Cidade atualizada com sucesso.'
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :status, :state, :unit_id, :fl_charge)
    end
end
