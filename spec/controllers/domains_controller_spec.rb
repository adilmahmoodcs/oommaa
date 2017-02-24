require 'rails_helper'

RSpec.describe DomainsController, type: :controller do
  let(:valid_attributes) {
    {
      name: Faker::Internet.domain_name
    }
  }

  let(:invalid_attributes) {
    {
      name: ""
    }
  }

  before(:each) do
    login_user
  end

  describe "GET #index" do
    it "assigns all domains as @domains" do
      domain = Domain.create! valid_attributes
        get :index, params: {}
      expect(assigns(:domains)).to eq([domain])
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Domain" do
        expect {
            post :create, params: {domain: valid_attributes}
        }.to change(Domain, :count).by(1)
      end

      it "assigns a newly created domain as @domain" do
        post :create, params: {domain: valid_attributes}
        expect(assigns(:domain)).to be_a(Domain)
        expect(assigns(:domain)).to be_persisted
      end

      it "redirects to the created domain" do
          post :create, params: {domain: valid_attributes}
        expect(response).to redirect_to(domains_path)
      end

      it "calls Domain#update_posts!" do
        expect_any_instance_of(Domain).to receive(:update_posts!)
        post :create, params: {domain: valid_attributes}
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved domain as @domain" do
          post :create, params: {domain: invalid_attributes}
        expect(assigns(:domain)).to be_a_new(Domain)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested domain" do
      domain = Domain.create! valid_attributes
      expect {
          delete :destroy, params: {id: domain.to_param}
      }.to change(Domain, :count).by(-1)
    end

    it "redirects to the domains list" do
      domain = Domain.create! valid_attributes
      delete :destroy, params: {id: domain.to_param}
      expect(response).to redirect_to(domains_url)
    end
  end

  describe "POST #change_status" do
    it "changes status" do
      domain = Domain.create! valid_attributes
      post :change_status, params: {domain_id: domain.id, status: :whitelisted}
      expect(assigns(:domain)).to be_whitelisted

      post :change_status, params: {domain_id: domain.id, status: :blacklisted}
      expect(assigns(:domain)).to be_blacklisted
    end

    it "calls Domain#update_posts!" do
      domain = Domain.create! valid_attributes
      expect_any_instance_of(Domain).to receive(:update_posts!)
      post :change_status, params: {domain_id: domain.id, status: :whitelisted}
    end
  end

end
