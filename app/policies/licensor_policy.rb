class LicensorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def search?
    user.admin?
  end

  def cease_and_desist_email?
    user.admin?
  end

  def send_cease_and_desist_email?
    user.admin?
  end
end
