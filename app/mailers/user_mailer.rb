class UserMailer < ApplicationMailer
  default to: Proc.new { User.admin.pluck(:email) },
          from: "CounterFind <info@counterfind.com>"

  def user_domain_request user:, domain:
    @user = user
    @domain_name = domain.name
    @domain_status = domain.status
    mail(subject: 'Domain request from  #{@user.name}')
  end
end
