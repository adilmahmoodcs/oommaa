class LicensorMailer < ApplicationMailer
  def notify_reported_post(licensor, post)
    return if licensor.main_contact.blank?

    @post = post
    mail(to: licensor.main_contact, subject: "CounterFind")
  end
end
