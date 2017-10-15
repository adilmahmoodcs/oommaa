class EmployeeDataReport
  attr_reader :employee, :output_format

  def initialize(employee, output_format=:html)
    @employee = employee
    @output_format = output_format
  end

  def association_name(attr)
    attr.to_sym
  end

  def associate_data(attr)
    employee.send(association_name(attr))
  end

  def get_has_many_record(attr, attr_param)
    as_records = associate_data(attr)
    attr_param.map do |k, v|
      attr_val = as_records.try(:map) do |as_record|
        as_record_val = as_record.send(k)
        as_record_val = formating_attr_val(as_record_val)
      end.join(', ')
      attr_val_output_format(attr_val)
    end
  end

  def get_has_one_record(attr, attr_param)
    as_record = associate_data(attr)
    attr_param.map do |k, v|
      attr_val = as_record.present? ? as_record.send(k) : "N/A"
      attr_val = formating_attr_val(attr_val)
      attr_val_output_format(attr_val)
    end
  end

  def get_self_attr_record(attr, attr_param)
    attr_val = employee.send(attr).present? ? employee.send(attr) : "N/A"
    attr_val = formating_attr_val(attr_val)
    attr_val_output_format(attr_val)
  end

  def attr_val_output_format(attr_val)
    if output_format == :html
      wrap_td(attr_val)
    else
      attr_val
    end
  end

  def wrap_td(attr_val)
    "<td>#{attr_val}</td>"
  end

  def formating_attr_val(attr_val)
    if attr_val.class == ActiveSupport::TimeWithZone
      attr_val.strftime('%b %d, %Y')
    elsif attr_val.class == TrueClass
      attr_val.present? ? attr_val : false
    elsif attr_val.blank?
      "N/A"
    else
      attr_val
    end

  end

  def emp_attr_record(relation_type, attr, attr_param)
    if relation_type == "has_many"
      get_has_many_record(attr, attr_param)
    elsif relation_type == "has_one"
      get_has_one_record(attr, attr_param)
    else
      get_self_attr_record(attr, attr_param)
    end
  end
end
