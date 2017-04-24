require 'rails_helper'

RSpec.describe PostBrand, type: :model do
  subject {PostBrand}
  let(:facebook_post) { create(:facebook_post) }
  let!(:brand) { create(:brand) }

  describe "should Pass all the validations" do
    it "should create brand for post" do
      facebook_post.post_brands.create(brand_id: brand.id)
      expect(facebook_post.manual_added_brands.count).to eq(1)
    end

    it "should only create one record against same user and same domain" do
      facebook_post.post_brands.create(brand_id: brand.id)
      facebook_post.post_brands.create(brand_id: brand.id)
      facebook_post.post_brands.create(brand_id: brand.id)
      expect(PostBrand.count).to eq(1)
    end
  end
end
