class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update]
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @histories = index_class(History)
    respond_with @histories, :layout => 'application'
  end

  def show
  end

  def new
    @history = History.new
    @history.unit_id = session[:unit_id]
    @history.client_id = session[:client_id]
    @history.taxpayer_id = session[:taxpayer_id]
    @history.user_id = current_user.id
    @history.history_date = Time.current
  end

  def edit
    if @history.user_id != current_user.id
      flash[:alert] = 'Você não pode editar histórico de outros colaboradores!'
      redirect_to( show_path(session[:taxpayer_id])) and return
    end
  end

  def create
    @history = History.new(history_params)
    @history.save
    redirect_to( show_path(session[:taxpayer_id]) )
  end

  def update
    @history.update_attributes(history_params)

    flash[:notice] = 'Histórico atualizado com sucesso.'
    redirect_to show_path(@history.taxpayer_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    def history_params
      params.require(:history).permit(:description, :history_date, :unit_id, :client_id, :taxpayer_id, :user_id, :word_id)
    end
end
