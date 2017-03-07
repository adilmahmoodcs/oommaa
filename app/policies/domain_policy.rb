class DomainPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def change_status?
    user.admin?
  end
end
