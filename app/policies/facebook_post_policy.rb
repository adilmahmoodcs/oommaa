class FacebookPostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def export?
    user.admin?
  end

  def change_status?
    user.admin?
  end

  def mass_change_status?
    user.admin?
  end
end
