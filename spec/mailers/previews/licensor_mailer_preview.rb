# Preview all emails at http://localhost:3000/rails/mailers/licensor_mailer
class LicensorMailerPreview < ActionMailer::Preview
  def notify_reported_post
    licensor = Licensor.last
    post = FacebookPost.last
    LicensorMailer.notify_reported_post(licensor, post)
  end
end
