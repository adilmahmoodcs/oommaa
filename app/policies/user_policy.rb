class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_right?(:view_users)
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.has_right?(:view_users)
  end

  def show?
    user.has_right?(:view_users)
  end

  def edit?
    user.has_right?(:edit_users)
  end

  def update?
    user.has_right?(:edit_users)
  end

  def new?
    user.has_right?(:create_user)
  end

  def create?
    user.has_right?(:create_user)
  end

  def destroy?
    user.has_right?(:delete_users)
  end

end
