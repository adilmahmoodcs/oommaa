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

    it "should only create one record against post user and same brand" do
      facebook_post.post_brands.create(brand_id: brand.id)
      facebook_post.post_brands.create(brand_id: brand.id)
      facebook_post.post_brands.create(brand_id: brand.id)
      expect(PostBrand.count).to eq(1)
    end

    it "should not create for empty brand" do
      facebook_post.post_brands.create(brand_id: "")
      expect(facebook_post.manual_added_brands.count).to eq(0)
      expect(PostBrand.count).to eq(0)
    end
  end
end
