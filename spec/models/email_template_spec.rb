require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do

  subject {EmailTemplate}
  let!(:admin_user) { create(:user) }
  let!(:licensor) {create(:licensor)}

  describe "should Pass all the validations and have all relations" do
    it "belongs to a parent" do
      email_template = licensor.email_templates.new
      expect(email_template.parent).to eq(licensor)
    end

    it "should not create if text is not present" do
      email_template = licensor.email_templates.create( default_subject: "Random body")
      expect(EmailTemplate.count).to eq(0)
    end

    it "should create if text is present" do
      email_template = licensor.email_templates.create(default_subject: "random subject", text: "Random body")
      expect(EmailTemplate.count).to eq(1)
    end
  end

end
