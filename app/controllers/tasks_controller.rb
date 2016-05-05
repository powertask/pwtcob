class TasksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js, :json
  layout 'window'





  private
    def setup_schedule_params
      params.require(:setup_schedule).permit(:name, :doctor_id, :day_of_month, :end_at, :interval, :start_at, :room_id, :count_event)
    end

end
