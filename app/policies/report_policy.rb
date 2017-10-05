class ReportPolicy < Struct.new(:user, :report)
  def any?
    team_production?
  end

  def team_production?
    user.admin?
  end

  def employees_data?
    user.has_right?(:get_report_all_employees) ||
    (user.has_right?(:get_report_managed_employees) && record.manager_id == user.id)
  end
end
