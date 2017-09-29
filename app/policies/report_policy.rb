class ReportPolicy < Struct.new(:user, :report)
  def any?
    team_production?
  end

  def team_production?
    user.admin?
  end
end
