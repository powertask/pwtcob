class HistoriesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @histories = index_class(History)
    respond_with @cities, :layout => 'application'
  end

  def show
  end

  def new
    @history = History.new
    @history.unit_id = session[:unit_id]
  end

  def edit
  end

  def create
    @history = History.new(history_params)
    @history.save
    respond_with @history, notice: 'Histórico criado com sucesso.'
  end

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
      params.require(:history).permit(:name, :status, :state, :unit_id, :fl_charge)
    end
end
