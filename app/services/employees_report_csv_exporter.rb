require "csv"

class EmployeesReportCSVExporter
  attr_reader :employees, :emp_params, :employees_data_report

  def initialize(employees, emp_params)
    @employees = employees
    @emp_params = emp_params
    @employees_data_report = EmployeesDataReport.new(@employees, @emp_params, :csv)
  end

  def call
    ::CSV.generate(csv_options) do |csv|
      csv << employees_data_report.emp_report_columns_name
      employees_data_report.emp_report_data.each do |d|
        csv << d
      end
    end
  end

  private

  def csv_options
    {}
  end
end
