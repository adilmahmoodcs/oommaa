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
      set_rights
      @employee.create_activity(:create, owner: current_user, parameters: { name: @employee.name })
      redirect_to employees_path, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @employee
    if @employee.update(employee_params)
      set_rights
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
    params.require(:employee).permit(:name, :right_ids)
  end

  # def set_rights
  #   params[:right_ids].each do |right_id, result|
  #     if result.to_s=='true'
  #       EmployeeRight.find_or_create_by(right_id: right_id, employee_id: params[:id])
  #     else
  #       EmployeeRight.where(right_id: right_id, employee_id: params[:id]).delete_all
  #     end
  #   end
  # end

end
