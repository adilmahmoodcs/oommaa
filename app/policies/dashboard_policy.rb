class DashboardPolicy < Struct.new(:user, :dashboard)
  def index?
    user
  end
end
