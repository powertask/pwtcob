class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @users = User.where('unit_id = ?', session[:unit_id])
    respond_with @users, :layout => 'application'
  end

  def new
    super do |resource|
      BackgroundWorker.trigger(resource)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_with(@user)
  end

end
