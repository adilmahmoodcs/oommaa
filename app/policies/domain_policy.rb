class DomainPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.confirmed_client?
        scope.of_confirmed_client(user)
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.confirmed_client?
  end

  def edit?
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
    user.admin? || user.confirmed_client?
  end

  def change_status?
    user.admin? || user.confirmed_client?
  end
end
