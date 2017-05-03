class LicensorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def search?
    user.admin?
  end
end
