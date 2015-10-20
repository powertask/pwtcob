class EmployeesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def index
    @employees = index_class(Employee)
    respond_with @employees, :layout => 'application'
  end

  def show
    @employee = Employee.find(params[:id])
    respond_with @employee
  end

  def new
    @employee = Employee.new
    respond_with @employee
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.unit_id = session[:unit_id]
    @employee.save!
    respond_with @employee
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @employee
  end

  def update
    @employee = Employee.find(params[:id])
    @employee.update_attributes(employee_params)
    respond_with @employee
  end

  private
    def employee_params
      params.require(:employee).permit( :name, :unit_id, :email, :phone, :fee )
    end
end
