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
    set_child_objects
  end

  def edit
    authorize @employee
    set_child_objects
  end

  def create
    authorize Employee
    @employee = Employee.new(employee_params)

    if @employee.save
      @employee.create_activity(:create, owner: current_user, parameters: { name: @employee.name })
      redirect_to employees_path, notice: 'Employee was successfully created.'
    else
      set_child_objects
      render :new
    end
  end

  def update
    authorize @employee
    if @employee.update(employee_params)
      @employee.create_activity(:update, owner: current_user, parameters: { name: @employee.name })
      redirect_to employees_path, notice: 'Employee was successfully updated.'
    else
      set_child_objects
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

  def set_child_objects
    @visa_detail = @employee.visa_detail || @employee.build_visa_detail
    @trainings = @employee.trainings.present? ? @employee.trainings :  @employee.trainings.new
  end

  def employee_params
    params.require(:employee).permit(
      :name, :phone, :dob, :manager_id,
      visa_detail_attributes: [
        :id,
        :visa_id,
        :name,
        :issue,
        :finish,
        :completed,
        :notes
      ],
      trainings_attributes: [
        :id,
        :name,
        :location,
        :duration,
        :provider,
        :confirmation,
        :start_date,
        :end_date,
        :notes,
        :_destroy
      ]

    )
  end

end
