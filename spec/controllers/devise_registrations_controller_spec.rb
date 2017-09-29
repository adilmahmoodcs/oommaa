require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  let(:licensor) { create(:licensor) }
  let(:valid_attributes) {
    {
      email: Faker::Internet.safe_email,
      password: "password",
      password_confirmation: "password",
      name: Faker::Name.name,
      licensor_id: licensor.id
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end
    end
  end
end
