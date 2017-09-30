class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_right?(:view_roles)
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.has_right?(:view_roles)
  end

  def show?
    user.has_right?(:view_roles)
  end

  def edit?
    user.has_right?(:edit_roles)
  end

  def update?
    user.has_right?(:edit_roles)
  end

  def new?
    user.has_right?(:create_role)
  end

  def create?
    user.has_right?(:create_role)
  end

  def destroy?
    user.has_right?(:delete_roles)
  end

end
