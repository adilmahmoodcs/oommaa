class FacebookPostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
        scope.all
    end
  end

  def export?
    user.admin?
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
  end

  def index_suspect?
    user.admin?
  end

  def index_whitelisted?
    user.admin?
  end

  def index_blacklisted?
    user.admin?
  end

  def index_reported_to_facebook?
    user.admin?
  end

  def index_ignored?
    user.admin?
  end

  def index_greylisted?
    user.admin?
  end

  def index_affiliate_greylisted?
    user.admin?
  end

  def index_shutdown_queue?
    user.admin?
  end

  ### change_status

  def change_status_not_suspect?
    user.admin?
     # ||
    # (user.confirmed_client? && user.licensor.id.in?(record.licensor_ids))
  end

  def change_status_suspect?
    user.admin?
  end

  def change_status_whitelisted?
    user.admin?
  end

  def change_status_blacklisted?
    user.admin?
  end

  def change_status_reported_to_facebook?
    user.admin?
  end

  def change_status_ignored?
    user.admin?
  end

  def change_status_greylisted?
    user.admin?
  end

  def change_status_affiliate_greylisted?
    user.admin?
  end

  def change_status_shutdown_queue?
    user.admin?
  end

  ### mass_change_status

  def mass_change_status_not_suspect?
    user.admin?
  end

  def mass_change_status_suspect?
    user.admin?
  end

  def mass_change_status_whitelisted?
    user.admin?
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

  def mass_change_status_greylisted?
    user.admin?
  end

  def mass_change_status_affiliate_greylisted?
    user.admin?
  end

  def mass_change_status_shutdown_queue?
    user.admin?
  end
end
