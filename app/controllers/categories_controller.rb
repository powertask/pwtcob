class CategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @categories = index_class(Category)
    respond_with @categories, :layout => 'application'
  end

  def show
    @category = Category.find(params[:id])
    respond_with @action
  end

  def new
    @category = Category.new
    respond_with @category
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    @category.unit_id = session[:unit_id]
    @category.save!
    respond_with @category
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @category
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(category_params)
    respond_with @category
  end

  private
    def category_params
      params.require(:category).permit(:name, :unit_id)
    end
end
