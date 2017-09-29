require 'rails_helper'

RSpec.describe AssignedDomainsController, type: :controller do
  let(:domain) { create(:domain) }
  let!(:admin_user) { create(:user) }
  let!(:confirmed_user) { create(:user, role: :confirmed_client) }

  before(:each) do
    login_user
  end

  describe "#create" do
    it "doesn't create assigned domain for admin user" do
        post :create, params: { assigned_domain_id: domain.id, user_id: admin_user.id, format: :js }
      expect(AssignedDomain.count).to eq(0)
    end

    it "return @response not to be true for admin" do
        post :create, params: { assigned_domain_id: domain.id, user_id: admin_user.id, format: :js }
      expect(assigns(:response)).not_to eq(true)
    end

    it "should create AssignedDomain for confirmed_client" do
        post :create, params: { assigned_domain_id: domain.id, user_id: confirmed_user.id, format: :js }
      expect(AssignedDomain.count).to eq(1)
    end

    it "should return true as @response" do
        post :create, params: { assigned_domain_id: domain.id, user_id: confirmed_user.id, format: :js }
      expect(assigns(:response)).to eq(true)
    end
  end

  describe "#destroy" do
    it "should delete assigned domain record successfully" do
      confirmed_user.assigned_domains.create(domain_id: domain.id)
        delete :destroy, params: { id: domain.id, user_id: confirmed_user.id }
      expect(AssignedDomain.count).to eq(0)
    end
  end
end
