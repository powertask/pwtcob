class TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js, :json
  layout 'window'
require 'pry'
  def get_tasks
    
    @tasks = Task.where("unit_id = ? AND user_id = ?", session[:unit_id], current_user.id)

    tasks = []
    @tasks.each do |task|
      tasks << {:id => task.id, :title => task.description, :start => "#{task.task_date.to_date}", :end => "#{task.task_date.to_date}", :allDay => true, :recurring => false }
    end
    render :text => tasks.to_json
  end

  def get_click
    binding.pry;
    taxpayer = Taxpayer.find( params[:id] )
    show_path(taxpayer)
  end


  private
    def setup_schedule_params
      params.require(:setup_schedule).permit(:name, :doctor_id, :day_of_month, :end_at, :interval, :start_at, :room_id, :count_event)
    end

end
