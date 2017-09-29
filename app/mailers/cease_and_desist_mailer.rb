class CeaseAndDesistMailer < ApplicationMailer
  default from: "CounterFind <info@counterfind.com>"

  def sent_email(email_data)
    subject = email_data.subject
    email = email_data.email
    cc_emails = email_data.cc_emails
    @body = email_data.body
    mail(to: email, cc: cc_emails || '', subject: subject )
  end
end

