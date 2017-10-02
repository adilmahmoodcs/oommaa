class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  def index
    authorize Employee
    @q = policy_scope(Employee).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @employees = @q.result.
                 page(params[:page])
  end

  def show
    authorize @employee
  end

  def new
    authorize Employee
    @employee = Employee.new
  end

  def edit
    authorize @employee
  end

  def create
    authorize Employee
    @employee = Employee.new(employee_params)

    if @employee.save
      @employee.create_activity(:create, owner: current_user, parameters: { name: @employee.name })
      redirect_to employees_path, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @employee
    if @employee.update(employee_params)
      @employee.create_activity(:update, owner: current_user, parameters: { name: @employee.name })
      redirect_to employees_path, notice: 'Employee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @employee
    @employee.create_activity(:destroy, owner: current_user, parameters: { name: @employee.name })
    @employee.destroy
    redirect_to employees_path, notice: 'Employee was successfully destroyed.'
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :phone, :dob, :manager_id)
  end

end
