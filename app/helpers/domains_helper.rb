module DomainsHelper
  def user_domains user: , status:
    if current_user.admin?
      policy_scope(Domain).public_send(status)
    else
      policy_scope(current_user).domains.public_send(status)
    end
  end
end
