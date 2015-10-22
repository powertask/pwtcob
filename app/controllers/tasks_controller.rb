class TasksController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @tasks = index_class(Task)
    respond_with @tasks, :layout => 'application'
  end

  def show
    @task = Task.find(params[:id])
    respond_with @task
  end

  def new
    @task = Task.new
    respond_with @task
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.unit_id = session[:unit_id]
    @task.save!
    respond_with :root
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @task
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    respond_with :root
  end

  private
    def task_params
      params.require(:task).permit( :name, :unit_id, :description, :employee_id, :taxpayer_id, :task_date, :category_id )
    end
end
