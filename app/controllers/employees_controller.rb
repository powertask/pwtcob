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

  def report_fee_filter
    @months = [['Janeiro',1],['Fevereiro',2],['Março',3],['Abril',4],['Maio',5],['Junho',6],['Julho',7],['Agosto',8],['Setembro',9],['Outubro',10],['Novembro',11],['Dezembro',12]]
    @years = [['2016',2016]]
  end

  def report_fee_action
    dt_ini = Date.new(params[:year].to_i, params[:month].to_i, 1)
    dt_fim = ((dt_ini + 1.month))
    @rels = Contract.find_by_sql(['select employee_id, e.name, sum(paid_amount) paid_amount from contracts c, tickets t, employees e where c.id = t.contract_id and c.employee_id = e.id AND t.ticket_type = 1 and paid_amount > 0 AND t.status = 3  AND paid_at >= ? AND paid_at < ? group by employee_id, e.name', dt_ini, dt_fim])
  end


  private
    def employee_params
      params.require(:employee).permit( :name, :unit_id, :email, :phone, :fee )
    end
end
