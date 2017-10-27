class EmployeesController < ApplicationController
  include EmployeesHelper
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :set_current_page_var, only: [:new, :create, :edit, :update]
  # GET /employees
  def index
    authorize Employee
    @q = policy_scope(Employee).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @employees = @q.result.
                 includes(:manager, :visa_detail, :trainings).
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
      redirect_to_desire_page
    else
      set_child_objects
      render :new
    end
  end

  def update
    authorize @employee
    if @employee.update(employee_params)
      @employee.create_activity(:update, owner: current_user, parameters: { name: @employee.name })
      redirect_to_desire_page
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

  def set_current_page_var
    @current_page = params[:current_page].present? ? params[:current_page] : "basic_info"
  end

  def redirect_to_desire_page
    if params[:commit] == 'Save and Next'
      redirect_to edit_employee_path(@employee, {current_page: next_page}), notice: 'Saved successfully.'
    elsif params[:commit] == 'Save and Close'
      redirect_to employee_redirect_url_on_edit(@employee), notice: 'Saved successfully.'
    elsif params[:commit] == 'Save'
      redirect_to edit_employee_path(@employee, {current_page: @current_page}), notice: 'Saved successfully.'
    else
      redirect_to edit_employee_path(@employee, {current_page: @current_page}), notice: 'Saved successfully.'
    end
  end

  def next_page
    case @current_page
    when 'basic_info'
      'educations'
    when 'educations'
      'certificates'
    when 'certificates'
      'trainings'
    when 'trainings'
      'technical_skills'
    when 'technical_skills'
      'languages'
    end
  end

  def set_child_objects
    @visa_detail = @employee.visa_detail || @employee.build_visa_detail
    @passport_detail = @employee.passport_detail || @employee.build_passport_detail
    @labor_card_detail = @employee.labor_card_detail || @employee.build_labor_card_detail
    @trainings = @employee.trainings.present? ? @employee.trainings :  @employee.trainings.new
    @certificates = @employee.certificates.present? ? @employee.certificates :  @employee.certificates.new
    @employee_projects = @employee.employee_projects.present? ? @employee.employee_projects :  @employee.employee_projects.new
    @technical_skills = @employee.technical_skills.present? ? @employee.technical_skills :  @employee.technical_skills.new
    @educations = @employee.educations.present? ? @employee.educations :  @employee.educations.new
    @languages = @employee.languages.present? ? @employee.languages :  @employee.languages.new
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
      passport_detail_attributes: [
        :id,
        :passport_no,
        :name,
        :issue,
        :finish,
        :completed,
        :notes
      ],
      labor_card_detail_attributes: [
        :id,
        :labor_card_id,
        :name,
        :issue,
        :finish,
        :completed,
        :notes
      ],
      educations_attributes: [
        :id,
        :degree,
        :department,
        :institution,
        :thesis,
        :still_studying,
        :entrance_date,
        :graduation,
        :notes,
        :_destroy
      ],
      certificates_attributes: [
        :id,
        :name,
        :provider,
        :confirmation,
        :completion_date,
        :notes,
        :_destroy
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
      ],
      technical_skills_attributes: [
        :id,
        :name,
        :level,
        :level_id,
        :provider,
        :confirmation,
        :notes,
        :_destroy
      ],
      languages_attributes: [
        :id,
        :name,
        :written_level,
        :speaking_level,
        :native_language,
        :confirmation,
        :notes,
        :_destroy
      ]
    )
  end

end
