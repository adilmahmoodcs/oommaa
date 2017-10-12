class EmployeesReportPresenter
  # attr_reader :employee, :link, :dropdown, :summary, :view_context
  attr_reader :employees, :emp_params, :has_many_associations, :has_one_associations, :belongs_to_associations, :view_context

  # delegate :design, :marketer_account, to: :campaign
  # delegate :format_date, :format_date_with_relative, :format_relative_time,
  #   :content_tag, :tooltip_help, :unknown_fulfillment_date, :pluralize,
  #   to: :view_context

  def initialize(view_context, emp_params, employees)
    @view_context = view_context
    @employees = employees
    @emp_params = emp_params
    @has_many_associations = Employee.reflect_on_all_associations(:has_many)
    @has_one_associations = Employee.reflect_on_all_associations(:has_one)
    @belongs_to_associations = Employee.reflect_on_all_associations(:belongs_to)
  end

  def emp_report_theads
    emp_report_columns_name.map do |name|
      "<th>#{name}</th>"
    end.join('').html_safe
  end

  def many_association?(name)
    has_many_associations.any? { |a| a.name == name.to_sym }
  end

  def single_association?(name)
    has_one_associations.any? { |a| a.name == name.to_sym } || belongs_to_associations.any? { |a| a.name == name.to_sym }
  end

  def any_association?(name)
    many_association?(name) || single_association?(name)
  end

  def own_field?
    employee.send(emp_param[0]).present?
  end

  def emp_report_columns_name
    emp_params.map do |key, value|
      attribute_columns_name(key, value)
    end.flatten
  end

  def attribute_columns_name(key, value)
    # if key == "trainings"
    #     ssss
    # end
    if any_association?(key)
      value.map do |k, v|
        "#{key} #{k}"
      end
    else
      "#{key}"
    end
  end

end
