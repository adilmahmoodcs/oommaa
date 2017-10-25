class EmployeesDataReport
  attr_reader :employees, :emp_params, :output_format, :has_many_associations, :has_one_associations, :belongs_to_associations

  def initialize(employees, emp_params, output_format)
    @employees = employees
    @emp_params = emp_params
    @output_format = output_format
    @has_many_associations = Employee.reflect_on_all_associations(:has_many)
    @has_one_associations = Employee.reflect_on_all_associations(:has_one)
    @belongs_to_associations = Employee.reflect_on_all_associations(:belongs_to)
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

  def emp_report_columns_name
    emp_params.map do |key, value|
      attribute_columns_name(key, value)
    end.flatten
  end

  def attribute_columns_name(key, value)
    if any_association?(key)
      klass = key.classify.constantize
      model_name = klass::REPORT_MODEL_NAME
      fields_name_hash = klass::REPORT_FIELDS
      value.map do |k, v|
        "#{beautify_name(model_name)} #{fields_name_hash[k.to_sym]}"
      end
    else
      Employee::REPORT_FIELDS[key.to_sym]
    end
  end

  def beautify_name(name)
    name.gsub('_', ' ').titleize
  end

  def relation_type(name)
    if many_association?(name)
      "has_many"
    elsif single_association?(name)
      "has_one"
    else
      "self attribute"
    end
  end

  def emp_report_data
    employees.map do |emp|
      presenter = EmployeeDataReport.new(
          emp,
          output_format
        )
      emp_attr_data  = emp_params.map do |key, value|
        presenter.emp_attr_record(relation_type(key), key, value)
      end
      emp_attr_data.flatten!
      output_format == :html ? emp_attr_tr(emp_attr_data) : emp_attr_data
    end
  end

  def emp_attr_tr(emp_attr_data)
    html = "<tr>"
    html += emp_attr_data.join('')
    html += "</tr>"
    html
  end

end
