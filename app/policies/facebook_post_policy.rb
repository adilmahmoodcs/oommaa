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

  def export?
    user.admin? || user.confirmed_client?
  end

  ### index

  def index_any?
    index_not_suspect? ||
    index_suspect? ||
    index_whitelisted? ||
    index_blacklisted? ||
    index_reported_to_facebook? ||
    index_ignored?
  end

  def index_not_suspect?
    user.admin? || user.confirmed_client?
  end

  def index_suspect?
    user.admin? || user.confirmed_client?
  end

  def index_whitelisted?
    user.admin? || user.confirmed_client?
  end

  def index_blacklisted?
    user.admin? || user.confirmed_client?
  end

  def index_reported_to_facebook?
    user.admin? || user.confirmed_client?
  end

  def index_ignored?
    user.admin? || user.confirmed_client?
  end

  ### change_status

  def change_status_not_suspect?
    user.admin? ||
    (user.confirmed_client? && user.licensor.in?(record.licensors))
  end

  def change_status_suspect?
    user.admin? ||
    (user.confirmed_client? && user.licensor.in?(record.licensors))
  end

  def change_status_whitelisted?
    user.admin? ||
    (user.confirmed_client? && user.licensor.in?(record.licensors))
  end

  def change_status_blacklisted?
    user.admin? ||
    (user.confirmed_client? && user.licensor.in?(record.licensors))
  end

  def change_status_reported_to_facebook?
    user.admin?
  end

  def change_status_ignored?
    user.admin?
  end

  ### mass_change_status

  def mass_change_status_not_suspect?
    user.admin? || user.confirmed_client?
  end

  def mass_change_status_suspect?
    user.admin? || user.confirmed_client?
  end

  def mass_change_status_whitelisted?
    user.admin? || user.confirmed_client?
  end

  def mass_change_status_blacklisted?
    user.admin?
  end

  def mass_change_status_reported_to_facebook?
    user.admin?
  end

  def mass_change_status_ignored?
    user.admin?
  end
end
