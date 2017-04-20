require 'rails_helper'

RSpec.describe AssignedDomain, type: :model do
  subject {AssignedDomain}
  let(:domain) { create(:domain) }
  let!(:admin_user) { create(:user) }
  let!(:confirmed_user) { create(:user, role: :confirmed_client) }
  let!(:unconfirmed_user) { create(:user, role: :unconfirmed_client) }

  describe "should Pass all the validations" do
    it "should not create for admin user" do
      admin_user.assigned_domains.create(domain_id: domain.id)
      expect(AssignedDomain.count).to eq(0)
    end

    it "should create for confirmed_user user" do
      confirmed_user.assigned_domains.create(domain_id: domain.id)
      expect(AssignedDomain.count).to eq(1)
    end

    it "should create for unconfirmed_user user" do
      unconfirmed_user.assigned_domains.create(domain_id: domain.id)
      expect(AssignedDomain.count).to eq(1)
    end

    it "should only create one record against same user and same domain" do
      unconfirmed_user.assigned_domains.create(domain_id: domain.id)
      unconfirmed_user.assigned_domains.create(domain_id: domain.id)
      unconfirmed_user.assigned_domains.create(domain_id: domain.id)
      expect(AssignedDomain.count).to eq(1)
    end
  end
end
