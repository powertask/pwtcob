class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @words = Word.where('unit_id = ?', session[:unit_id]).paginate(:page => params[:page], :per_page => 20)
    respond_with @words, :layout => 'application'
  end

  def show
    @word = Word.find(params[:id])
    respond_with @word
  end

  def new
    @word = Word.new
    @word.unit_id = session[:unit_id]
  end

  def edit
  end

  def create
    @word = Word.new(word_params)
    @word.save
    respond_with @word, notice: 'Historico padrão criado com sucesso.'
  end

  def update
    @word.update_attributes(word_params)
    respond_with @word, notice: 'Histórico padrão atualizado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:unit_id, :name)
    end
end
