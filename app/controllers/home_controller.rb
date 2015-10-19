class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
  end

end
