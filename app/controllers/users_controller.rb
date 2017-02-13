class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    unless current_user.admin?
      redirect_to :back, :alert => "Acesso permitido somente para ADMINISTADOR."
    end

    @users = User.where("unit_id = ? AND id not in (1,2)", session[:unit_id]).order('profile').paginate(:page => params[:page], :per_page => 20)
    respond_with @users, :layout => 'application'
  end


  def edit
    unless current_user.admin?
      redirect_to :back, :alert => "Acesso permitido somente para ADMINISTADOR."
    end
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    respond_with(@user)
  end

  def show
    unless current_user.admin?
      redirect_to :back, :alert => "Acesso permitido somente para ADMINISTADOR."
    end
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :phone, :profile, :fl_taxpayer)
    end

end
