class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html
  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
  end

  def filter_name
    @taxpayers = Taxpayer
                    .where("unit_id = ? AND lower(name) like ?", session[:unit_id], params[:name].downcase << "%")
                    .paginate(:page => params[:page], :per_page => 10)
                    .order('name ASC')
    render "index", :layout => 'application'
  end

  def show
    @taxpayer = Taxpayer.find(params[:id])
    @cnas = Cna.list(session[:unit_id]).where('taxpayer_id = ?', params[:id])
    @histories = History.list(session[:unit_id]).where('taxpayer_id = ?', params[:id])

    render "index", :layout => 'application'
  end

end
