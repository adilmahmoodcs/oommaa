module EmployeesHelper
  def employee_redirect_url_on_edit(employee)
    if policy(employee).index?
      employee_redirect_url = employees_path
    else
      employee_redirect_url = employee_path(employee)
    end
  end

  def set_active_class(current_page, li_page)
    current_page == li_page ? 'active' : ''
  end
end
