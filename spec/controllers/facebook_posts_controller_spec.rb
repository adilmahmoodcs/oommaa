require 'rails_helper'

RSpec.describe FacebookPostsController, type: :controller do
  let(:page) { create(:facebook_page) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:facebook_post, facebook_page_id: page.id) }
  let!(:statuses) { FacebookPost.statuses.keys }
  let!(:reported_to_facebook) { create(:facebook_post, status: :reported_to_facebook) }
  let!(:blacklisted) { create(:facebook_post, status: :blacklisted, blacklisted_at: Date.today,
                              facebook_page_id: page.id, blacklisted_by: 'test@test.com') }

  before(:each) do
    login_user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #change_status" do
    it "changes status" do
      facebook_post = FacebookPost.create! valid_attributes
      expect(statuses).to be_many

      expect_any_instance_of(FacebookPost).to receive(:change_status_to!)
      post :change_status, params: { post_id: facebook_post.id, status: :blacklisted }
    end

    it "calls ShutDownCheckerJob on reported_to_facebook status change" do
      facebook_post = FacebookPost.create! valid_attributes

      post :change_status, params: { post_id: facebook_post.id, status: :reported_to_facebook }
      expect(ShutDownCheckerJob.jobs.size).to eq(1)
    end

    it "does not call ShutDownCheckerJob on other status change" do
      facebook_post = FacebookPost.create! valid_attributes

      (statuses - ["reported_to_facebook"]).each do |status|
        post :change_status, params: { post_id: facebook_post.id, status: status }
        expect(ShutDownCheckerJob.jobs.size).to eq(0)
      end
    end

    it "calls PostScreenshotsJob on blacklisted status change" do
      facebook_post = FacebookPost.create! valid_attributes

      post :change_status, params: { post_id: facebook_post.id, status: :blacklisted }
      expect(PostScreenshotsJob.jobs.size).to eq(1)
    end

    it "does not call PostScreenshotsJob on other status change" do
      facebook_post = FacebookPost.create! valid_attributes

      (statuses - ["blacklisted"]).each do |status|
        post :change_status, params: { post_id: facebook_post.id, status: status }
        expect(PostScreenshotsJob.jobs.size).to eq(0)
      end
    end

    it "calls Domain.blacklist_new_domains! on blacklisted status change" do
      facebook_post = FacebookPost.create! valid_attributes

      expect(Domain).to receive(:blacklist_new_domains!)
      post :change_status, params: { post_id: facebook_post.id, status: :blacklisted }
    end

    it "does not call Domain.blacklist_new_domains! on other status change" do
      facebook_post = FacebookPost.create! valid_attributes

      (statuses - ["blacklisted"]).each do |status|
        expect(Domain).to_not receive(:blacklist_new_domains!)
        post :change_status, params: { post_id: facebook_post.id, status: status }
      end
    end

    describe "GET #blacklisted_export" do
      it "returns http success" do
        get :export
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #blacklisted_export should give posts with status blacklisted or reported_to_facebook" do
      it "returns http success" do
        get :export
        expect(response).to have_http_status(:success)
        expect(FacebookPost.blacklisted_or_reported_to_facebook.count).to eq(assigns(:posts).count)
      end
    end

    describe "GET #blacklisted_export with date filter should give posts within specified range" do
      it "returns http success" do
        get :export, params: { from: Date.today, to: Date.today }
        expect(response).to have_http_status(:success)
        expect(FacebookPost.blacklisted_or_reported_to_facebook.where("blacklisted_at >= ?", Date.today.beginning_of_day).count).to eq(assigns(:posts).count)
      end
    end

    describe "GET #blacklisted_export with FacebookPage filter should give posts within specified Page" do
      it "returns http success" do
        get :export, params: { :q => {facebook_page_id_eq: page.id}}
        expect(response).to have_http_status(:success)
        expect(FacebookPage.find(page.id).facebook_posts.count).to eq(assigns(:posts).count)
      end
    end

    describe "GET #blacklisted_export with Discovered by filter should give posts  discovered by specified user" do
      it "returns http success" do
        get :export, params: { :q => {blacklisted_by_eq: 'test@test.com'}}
        expect(response).to have_http_status(:success)
        expect(FacebookPost.where(blacklisted_by: "test@test.com").count).to eq(assigns(:posts).count)
      end
    end
  end

end
