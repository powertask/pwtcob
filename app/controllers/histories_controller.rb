class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update]
  before_action :authenticate_user!
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

  def report_count_contacts_filter
  end

  def report_count_contacts_action
    dt_ini = (params[:report][:ini_at]).to_date
    dt_end = (params[:report][:end_at]).to_date.end_of_day()
    
    @result = Array.new

    users = User.all
    users.each do |user|

      contacts = History.where('unit_id = ? and client_id = ? and user_id = ? and history_date between ? and ?', current_user.unit_id, session[:client_id], user.id, dt_ini, dt_end).group(:user_id, :taxpayer_id).order(:user_id).count

      if contacts.count > 0
        h = Hash.new
        h[:user_id] = user.id
        h[:user_name] = user.name
        h[:contacts] = contacts.count
        @result.push(h)
      end
    end
    @result.sort_by!{|e| -e[:contacts]}
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
