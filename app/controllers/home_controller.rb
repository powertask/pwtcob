class HomeController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js, :json
  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
  end

  def get_tasks
    events  = []
    @tasks = Task.where("unit_id = ?", session[:unit_id])

    @tasks.each do |task|
      if task.task_date.to_date ==  Date.today()
        ls_color  = 'red'
      else
        ls_color = 'dark-blue'
      end
      events << {:id => task.id, :title => task.category.name << " - " << task.taxpayer.name, :start => "#{task.task_date.to_date}", :end => "#{task.task_date.to_date}", :allDay => true, :recurring => false, color: ls_color}
    end
    render :text => events.to_json
  end

  def get_click
    @tasks = Task.find params[:id]

    respond_to do |format|
      format.js
    end
  end

end
