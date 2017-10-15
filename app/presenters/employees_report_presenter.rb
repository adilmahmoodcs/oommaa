class EmployeesReportPresenter
  attr_reader :employees, :emp_params, :output_format, :view_context

  def initialize(view_context, emp_params, employees, output_format)
    @view_context = view_context

    @employees = employees
    @emp_params = emp_params
    @output_format = output_format
    @employees_data_report = EmployeesDataReport.new(@employees, @emp_params, @output_format)
  end

  def emp_report_theads
    @employees_data_report.emp_report_columns_name.map do |name|
      "<th>#{name}</th>"
    end.join('').html_safe
  end

  def emp_report_data_as_html
    @employees_data_report.emp_report_data.join('').html_safe
  end

end
