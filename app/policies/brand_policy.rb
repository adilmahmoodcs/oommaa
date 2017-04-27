class BrandPolicy < ApplicationPolicy
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

  def update?
    user.admin? || user.confirmed_client?
  end

  def new?
    user.admin? || user.confirmed_client?
  end

  def create?
    user.admin? || user.confirmed_client?
  end
  def destroy?
    user.admin?
  end
end
