class FacebookPagePolicy < ApplicationPolicy
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
end
