class FacebookPostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.confirmed_client?
        scope.of_licensor(user.licensor)
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.confirmed_client?
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
