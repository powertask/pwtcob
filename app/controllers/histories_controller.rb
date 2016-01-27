class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @histories = index_class(History)
    respond_with @histories, :layout => 'application'
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @history = History.new
    @history.unit_id = session[:unit_id]
    @history.employee_id = session[:employee_id]
    @history.taxpayer_id = session[:taxpayer_id]
    @history.history_date = Time.current
  end

  # GET /cities/1/edit
  def edit
  end

  def create
    @history = History.new(history_params)
    @history.save
    redirect_to( show_path(session[:taxpayer_id]))
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    @city.update_attributes(city_params)
    respond_with @city, notice: 'Cidade atualizada com sucesso.'
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:description, :history_date, :unit_id, :taxpayer_id, :employee_id)
    end
end
