require 'rails_helper'

RSpec.describe SentEmail, type: :model do

  subject {SentEmail}
  let!(:admin_user) { create(:user) }
  let!(:email_template) {create(:email_template)}

  describe "should Pass all the validations and have all relations" do
    it "belongs to a user" do
      sent_email = admin_user.sent_emails.new
      expect(sent_email.user).to eq(admin_user)
    end

    it "belongs to a email_template" do
      sent_email = email_template.sent_emails.new
      expect(sent_email.email_template).to eq(email_template)
    end

    it "should not create is email is not present" do
      sent_email = email_template.sent_emails.create(subject: "random subject", body: "Random body", user: admin_user)
      expect(SentEmail.count).to eq(0)
    end

    it "should create if email is present" do
      sent_email = email_template.sent_emails.create(subject: "random subject", body: "Random body", user: admin_user, email: Faker::Internet.email)
      expect(SentEmail.count).to eq(1)
    end
  end
end
