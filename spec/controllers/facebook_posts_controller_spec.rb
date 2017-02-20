require 'rails_helper'

RSpec.describe FacebookPostsController, type: :controller do

  before(:each) do
    login_user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
