class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_right?(:view_all_employees)
        scope.all
      elsif user.has_right?(:view_managed_employees)
        scope.of_manager(user)
      else
        scope.none
      end
    end
  end

  def index?
    user.has_right?(:view_all_employees) || user.has_right?(:view_managed_employees)
  end

  def show?
    user.has_right?(:view_all_employees) ||
    (user.has_right?(:view_managed_employees) && record.manager_id == user.id) ||
    (user.has_right?(:view_own_record) && record.user_id == user.id)
  end

  def edit?
    user.has_right?(:edit_all_employees) ||
    (user.has_right?(:edit_managed_employees) && record.manager_id == user.id) ||
    (user.has_right?(:edit_own_record) && record.user_id == user.id)
  end

  def update?
    user.has_right?(:edit_all_employees) ||
    (user.has_right?(:edit_managed_employees) && record.manager_id == user.id) ||
    (user.has_right?(:edit_own_record) && record.user_id == user.id)
  end

  def new?
    user.has_right?(:create_employee)
  end

  def create?
    user.has_right?(:create_employee)
  end

  def destroy?
    user.has_right?(:delete_all_employees) ||
    (user.has_right?(:delete_managed_employees) && record.manager_id == user.id)
  end

end
